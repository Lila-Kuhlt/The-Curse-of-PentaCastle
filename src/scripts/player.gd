class_name Player

extends CharacterBody2D

const SPIKE_DAMAGE := 10
const SPIKE_DAMAGE_COOLDOWN := 0.7
const ATTACK_ANIMATION_LENGTH := 1.0
const KNOCKBACK_ENVELOPE: float = 0.86
const LOOK_AHEAD_MAX := 20.0
const LOOK_AHEAD_SPEED := 60.0
const MAX_LIFE: float = 100
const HEAL_ON_ROOM_CHANGE: float = MAX_LIFE / 2

# Ghosts
const Ghost = preload("res://scenes/ghost.tscn")

enum MovementPhase { STANDING = 0, ACCELERATING = 1, DECELERATING = 2, TURNING = 3 }

@onready var sprite := $Sprite
@onready var ui := $Camera2D/PlayerUI
@onready var hit_indicator := $HitIndicationAnimationPlayer
@onready var ghost_inventory := $GhostInventory
@onready var cam := $Camera2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var life := MAX_LIFE
var spike_damage_timer := 0.0
var colliding_spike := false
var shield_multiplier := 1.0
var attack_animation_t := 0.0

# Movement
var JUMP_VELOCITY := -300.0
var ADDITIONAL_FALLING_GRAVITY := 100.0
var COYOTE_TIME := 5
var JUMP_BUFFER_FRAMES := 5
var ACCELERATION_SPEED := 200.0
var DECELERATION_SPEED := 550.0
var TURNING_SPEED := 1500.0
var MAX_SPEED := 100.0
var EPSILON := 0.001
var movement_phase := MovementPhase.STANDING
var knockback := Vector2(0, 0)
var direction := 0.0
var walk_vel := 0.0
var lookahead := 0.0

# SFX
var movement_sfx_counter = 0
var last_frame_in_air = false

# Juice
var frames_since_ground := 0
var is_turned_right := true
var jump_buffer := 0

# Inventory
var spell_inventory: Array[SpellBook.Spells] = []
var active_spells: Array[bool] = []

signal life_changed(amount: int)

func _ready():
	hit_indicator.play("RESET")
	for i in SpellBook.Spells.values().size():
		active_spells.append(false)

func cast(spell: SpellBook.Spells, inventory_idx: int):
	if active_spells[spell]: return
	attack_animation_t = ATTACK_ANIMATION_LENGTH
	var spell_script = SpellBook.spell_scripts[spell]
	spell_script.cast(self, get_tree().get_nodes_in_group('enemies'))
	var spell_item_script = SpellBook.spell_item_scripts[spell]
	if spell_item_script.type == SpellBook.SpellType.PASSIVE:
		add_ghost(spell, spell_item_script.duration, inventory_idx)
		ui.mark_spell_item_panel(inventory_idx)
		active_spells[spell] = true

func _uncast(spell: SpellBook.Spells, ghost, inventory_idx: int):
	var spell_script = SpellBook.spell_scripts[spell]
	spell_script.uncast(self, get_tree().get_nodes_in_group('enemies'))
	ghost_inventory.erase(ghost)
	ui.unmark_spell_item_panel(inventory_idx)
	active_spells[spell] = false

func add_ghost(spell: SpellBook.Spells, duration, inventory_idx):
	var ghost: Node2D = Ghost.instantiate()
	ghost.init(spell)
	ghost_inventory.append(ghost)

	var timer := Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(_uncast.bind(spell, ghost, inventory_idx))
	ghost.add_child(timer)

func _set_flip(val: bool):
	if sprite.flip_h == val:
		return
	sprite.flip_h = val
	ghost_inventory.flip()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		last_frame_in_air = true
		velocity.y += gravity * delta
		if velocity.y >= 0.0:
			velocity.y += ADDITIONAL_FALLING_GRAVITY * delta

	if is_on_floor():
		if last_frame_in_air:
			SfxAudio.play_sfx(SfxAudio.Sound.STEP_DROP)
			last_frame_in_air = false
		frames_since_ground = 0
	else:
		frames_since_ground += 1


	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		jump_buffer = JUMP_BUFFER_FRAMES
	if jump_buffer > 0 and ((frames_since_ground <= COYOTE_TIME) or is_on_floor()):
		velocity.y = JUMP_VELOCITY
		frames_since_ground = COYOTE_TIME
		jump_buffer = 0
	if jump_buffer > 0:
		jump_buffer -= 1

	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("left", "right")
	if direction:
		_set_flip(direction < 0)
		lookahead = direction * LOOK_AHEAD_MAX
	cam.offset.x = move_toward(cam.offset.x, lookahead, LOOK_AHEAD_SPEED * delta)

	match movement_phase:
		MovementPhase.STANDING:
			walk_vel = 0
			if direction != 0:
				movement_phase = MovementPhase.ACCELERATING
		MovementPhase.ACCELERATING:
			if direction == 0:
				movement_phase = MovementPhase.DECELERATING
			elif (direction > 0) == is_turned_right:
				walk_vel = move_toward(walk_vel, MAX_SPEED * sign(direction),
					delta * abs(direction) * ACCELERATION_SPEED)
				if movement_sfx_counter == 0 and is_on_floor():
					SfxAudio.play_sfx(SfxAudio.Sound.STEP)
				movement_sfx_counter = (movement_sfx_counter + 1) % 60
			else:
				movement_phase = MovementPhase.TURNING
		MovementPhase.DECELERATING:
			if direction != 0:
				movement_phase = MovementPhase.ACCELERATING if sign(direction) == sign(walk_vel) else MovementPhase.TURNING
			else:
				walk_vel = move_toward(walk_vel, 0, delta * DECELERATION_SPEED)
				if abs(walk_vel) <= EPSILON:
					movement_phase = MovementPhase.STANDING
		MovementPhase.TURNING:
			if direction == 0:
				movement_phase = MovementPhase.DECELERATING
			else:
				walk_vel = move_toward(walk_vel, 0, delta * TURNING_SPEED)
				if abs(walk_vel) <= EPSILON:
					movement_phase =  MovementPhase.ACCELERATING
	is_turned_right = direction > 0
	velocity.x = walk_vel

	velocity += knockback * delta
	knockback *= KNOCKBACK_ENVELOPE

	if is_on_floor():
		if direction:
			sprite.animation = 'walk-attack' if attack_animation_t > 0.0 else 'walk'
		else:
			sprite.animation = 'attack' if attack_animation_t > 0.0 else 'idle'
	else:
		sprite.animation = 'jump'
	attack_animation_t = max(attack_animation_t - delta, 0.0)

	var old_pos := position

	move_and_slide()
	for ghost in ghost_inventory.get_children():
		ghost.position -= position - old_pos
	spike_damage_timer = max(spike_damage_timer - delta, 0.0)
	if colliding_spike and not spike_damage_timer:
		take_damage(SPIKE_DAMAGE)
		spike_damage_timer = SPIKE_DAMAGE_COOLDOWN

	if global_position.y > 1000 or life <= 0:
		game_over()

func give_spell_item(spell: SpellBook.Spells):
	spell_inventory.append(spell)
	ui.add_spell_item_panel(spell)

func game_over():
	get_tree().reload_current_scene()

func take_damage(dmg: int):
	SfxAudio.play_sfx(SfxAudio.Sound.HIT)
	life -= dmg * shield_multiplier
	life_changed.emit(life)
	hit_indicator.play('hit')

func heal(amount: int):
	life += amount
	life = min(life, MAX_LIFE)
	life_changed.emit(life)

func enable_shield(strength: float):
	shield_multiplier = strength
	$Shield.visible = true

func disable_shield():
	shield_multiplier = 1.0
	$Shield.visible = false

func _on_pentagram_layer_combo_done(combo: Array[int]):
	var spell = SpellBook.find_spell(combo)
	if spell > 0:
		var idx = spell_inventory.find(spell)
		if (idx > -1):
			cast(spell, idx)
			return

	SfxAudio.play_sfx(SfxAudio.Sound.DRAW_INVALID)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is TileMap: colliding_spike = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is TileMap: colliding_spike = false
