extends CharacterBody2D

const JUMP_VELOCITY := -250.0
const ADDITIONAL_FALLING_GRAVITY := 400.0
const AIR_JUMP_FRAMES := 5
const JUMP_BUFFER_FRAMES := 5
const ACCELERATION_SPEED := 200.0
const DECELERATION_SPEED := 400.0
const TURNING_SPEED := 1000.0
const MAX_SPEED = 100.0
const EPSILON := 0.001
var frames_since_ground := 0
var is_turned_right := true
var jump_buffer := 0

enum MovementPhase { STANDING = 0, ACCELERATING = 1, DECELERATING = 2, TURNING = 3 }
var movement_phase := MovementPhase.STANDING

@onready var sprite := $Sprite

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


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
	if jump_buffer > 0 and ((frames_since_ground <= AIR_JUMP_FRAMES) or is_on_floor()):
		velocity.y = JUMP_VELOCITY
		frames_since_ground = AIR_JUMP_FRAMES
		jump_buffer = 0
	if jump_buffer > 0:
		jump_buffer -= 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction: sprite.flip_h = direction < 0

	if movement_phase == MovementPhase.STANDING:
		velocity.x = 0
		if direction:
			movement_phase = MovementPhase.ACCELERATING
	elif movement_phase == MovementPhase.ACCELERATING:
		if not direction:
			movement_phase = MovementPhase.DECELERATING
		elif (direction > 0) == is_turned_right:
			velocity.x = move_toward(velocity.x, MAX_SPEED * sign(direction),
				delta * abs(direction) * ACCELERATION_SPEED)
		else:
			movement_phase = MovementPhase.TURNING
	elif movement_phase == MovementPhase.DECELERATING:
		if direction:
			movement_phase = MovementPhase.ACCELERATING if sign(direction) == sign(velocity.x) else MovementPhase.TURNING
		else:
			velocity.x = move_toward(velocity.x, 0, delta * DECELERATION_SPEED)
			if abs(velocity.x) <= EPSILON:
				movement_phase = MovementPhase.STANDING
	elif movement_phase == MovementPhase.TURNING:
		if not direction:
			movement_phase = MovementPhase.DECELERATING
		else:
			velocity.x = move_toward(velocity.x, 0, delta * TURNING_SPEED)
			if abs(velocity.x) <= EPSILON:
				movement_phase =  MovementPhase.ACCELERATING
	is_turned_right = direction > 0

	move_and_slide()

	if global_position.y > 200:
		game_over()

func game_over():
	get_tree().reload_current_scene()
