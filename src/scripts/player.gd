extends CharacterBody2D

@onready var sprite := $Sprite
@onready var ui := $Camera2D/PlayerUI
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var LIFE = 100

# Movement
var JUMP_VELOCITY := -250.0
var ADDITIONAL_FALLING_GRAVITY := -200.0
var COYOTE_TIME := 5
var JUMP_BUFFER_FRAMES := 5
var ACCELERATION_SPEED := 200.0
var DECELERATION_SPEED := 400.0
var TURNING_SPEED := 1000.0
var MAX_SPEED := 100.0
var EPSILON := 0.001
const KNOCKBACK_ENVELOPE: float = 0.86
enum MovementPhase { STANDING = 0, ACCELERATING = 1, DECELERATING = 2, TURNING = 3 }
var movement_phase := MovementPhase.STANDING
var knockback := Vector2(0, 0)
var direction := 0.0

# Juice
var frames_since_ground := 0
var is_turned_right := true
var jump_buffer := 0

# Inventory
var spell_inventory: Array[SpellBook.Spells] = []
var active_spells: Array[bool] = []

# Ghosts
const Ghost = preload("res://scenes/ghost.tscn")
var ghost_arr: Array[Node2D] = []

func _ready():
	for i in SpellBook.Spells.values().size():
		active_spells.append(false)
		ghost_arr.append(null)

func cast(spell: SpellBook.Spells, inventory_idx: int):
	if (active_spells[spell]): return
	var spell_script = SpellBook.spell_scripts[spell]
	spell_script.cast(self, get_tree().get_nodes_in_group('enemies'))
	var spell_item_script = SpellBook.spell_item_scripts[spell].new()
	if spell_item_script.type == SpellBook.SpellType.PASSIVE:
		add_ghost(spell)
		ui.mark_spell_item_panel(inventory_idx)
		var timer := Timer.new()
		active_spells[spell] = true
		add_child(timer)
		timer.wait_time = spell_item_script.duration
		timer.one_shot = true
		timer.timeout.connect(_uncast.bind(spell, inventory_idx))
		timer.start()

func _uncast(spell: SpellBook.Spells, inventory_idx: int):
	del_ghost(spell)
	ui.unmark_spell_item_panel(inventory_idx)
	var spell_script = SpellBook.spell_scripts[spell]
	spell_script.uncast(self, get_tree().get_nodes_in_group('enemies'))
	active_spells[spell] = false

func add_ghost(spell: SpellBook.Spells):
	var ghost: Node2D = Ghost.instantiate()
	ghost_arr[spell] = ghost
	var num_ghosts: int = ghost_arr.reduce(func(accum, elem): return accum + 1 if elem != null else accum, 0)
	ghost.init(spell, num_ghosts - 1)
	add_child(ghost)

func del_ghost(spell: SpellBook.Spells):
	var ghost: Node2D = ghost_arr[spell]
	ghost_arr[spell] = null
	remove_child(ghost)
	ghost.queue_free()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y >= 0.0:
			velocity.y += ADDITIONAL_FALLING_GRAVITY * delta

	if is_on_floor():
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
	if direction: sprite.flip_h = direction < 0

	match movement_phase:
		MovementPhase.STANDING:
			velocity.x = 0
			if direction != 0:
				movement_phase = MovementPhase.ACCELERATING
		MovementPhase.ACCELERATING:
			if direction == 0:
				movement_phase = MovementPhase.DECELERATING
			elif (direction > 0) == is_turned_right:
				velocity.x = move_toward(velocity.x, MAX_SPEED * sign(direction),
					delta * abs(direction) * ACCELERATION_SPEED)
			else:
				movement_phase = MovementPhase.TURNING
		MovementPhase.DECELERATING:
			if direction != 0:
				movement_phase = MovementPhase.ACCELERATING if sign(direction) == sign(velocity.x) else MovementPhase.TURNING
			else:
				velocity.x = move_toward(velocity.x, 0, delta * DECELERATION_SPEED)
				if abs(velocity.x) <= EPSILON:
					movement_phase = MovementPhase.STANDING
		MovementPhase.TURNING:
			if direction == 0:
				movement_phase = MovementPhase.DECELERATING
			else:
				velocity.x = move_toward(velocity.x, 0, delta * TURNING_SPEED)
				if abs(velocity.x) <= EPSILON:
					movement_phase =  MovementPhase.ACCELERATING
	is_turned_right = direction > 0
	var old_pos := position

	velocity += knockback
	knockback *= KNOCKBACK_ENVELOPE
	move_and_slide()
	for ghost in ghost_arr:
		if (ghost == null): continue
		ghost.position -= position - old_pos
		ghost.flipped = sprite.flip_h

	if global_position.y > 200 or LIFE <= 0:
		game_over()

func give_spell_item(spell: SpellBook.Spells):
	spell_inventory.append(spell)
	ui.add_spell_item_panel(spell)

func game_over():
	get_tree().reload_current_scene()


func _on_pentagram_layer_combo_done(combo: Array[int]):
	var combo_str = "".join(combo)
	var spell = SpellBook.find_spell(combo_str)
	if ((spell > 0)):
		var idx = spell_inventory.find(spell)
		if (idx > -1):
			cast(spell, idx)
			return

	# TODO: negative feedback
