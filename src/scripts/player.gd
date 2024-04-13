extends CharacterBody2D

@onready var sprite := $Sprite
@onready var ui := $Camera2D/PlayerUI
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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
enum MovementPhase { STANDING = 0, ACCELERATING = 1, DECELERATING = 2, TURNING = 3 }
var movement_phase := MovementPhase.STANDING

# Juice
var frames_since_ground := 0
var is_turned_right := true
var jump_buffer := 0

# Inventory
var spell_inventory: Array[SpellBook.Spells] = []

const Ghost = preload("res://scenes/ghost.tscn")

var ghost_arr: Array[Node2D] = []

func add_ghost(index: int, id: int):
	var ghost: Node2D = Ghost.instantiate()
	ghost.init(index, id)
	ghost_arr.insert(index, ghost)
	add_child(ghost)

func del_ghost(index: int):
	var ghost: Node2D = ghost_arr.pop_at(index)
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
	var direction := Input.get_axis("left", "right")
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
	move_and_slide()
	for ghost in ghost_arr:
		ghost.position -= position - old_pos
		ghost.flipped = sprite.flip_h

	if global_position.y > 200:
		game_over()

func give_spell_item(spell: SpellBook.Spells):
	spell_inventory.append(spell)
	ui.add_spell_item_panel(spell)


func game_over():
	get_tree().reload_current_scene()


func _on_pentagram_layer_combo_done(combo: Array[int]):
	var combo_str = "".join(combo)
	var spell = SpellBook.find_spell(combo_str)
	if ((spell >= 0)):
		var idx = spell_inventory.find(spell)
		if (idx > -1):
			SpellBook.cast(spell, idx, self)
			return

	# TODO: negative feedback
