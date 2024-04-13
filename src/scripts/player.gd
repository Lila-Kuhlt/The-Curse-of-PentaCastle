extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -200.0
const AIR_JUMP_FRAMES := 3
var frames_since_ground := 0
@onready var sprite := $Sprite
@onready var progress: ProgressBar = $LvlProgress

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor():
		frames_since_ground = 0
	else:
		frames_since_ground += 1

	# Handle jump.
	if Input.is_action_just_pressed("jump") and ((frames_since_ground <= AIR_JUMP_FRAMES) or is_on_floor()):
		velocity.y = JUMP_VELOCITY
		frames_since_ground = AIR_JUMP_FRAMES

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if (Input.is_action_pressed("right") && sprite.scale.x >= 0): sprite.scale.x *= -1
	elif (Input.is_action_pressed("left") && sprite.scale.x <= 0): sprite.scale.x *= -1
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	progress.value = position.x / 3.7

	if global_position.y > 200:
			game_over()

func game_over():
	get_tree().reload_current_scene()
