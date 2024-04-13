extends Enemy

enum UnicornMode { CHARGE, STAND, WALK }

const MIN_WALK_COOLDOWN := 100
const MAX_WALK_COOLDOWN := 300
const MIN_STAND_COOLDOWN := 100
const MAX_STAND_COOLDOWN := 400
const WALK_MULT := 0.6
const CHARGE_MULT := 4.0
const VIEW_RAY_WIDTH := 10.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody2D = get_tree().root.get_node('World/Player')

var mode := UnicornMode.STAND
var mode_cooldown := 100
var was_on_wall_cooldown := 0.0

func goto_stand_mode():
	mode = UnicornMode.STAND
	anim.play('idle')
	mode_cooldown = randi_range(MIN_STAND_COOLDOWN, MAX_STAND_COOLDOWN)

func goto_walk_mode(toggle: bool):
	mode = UnicornMode.WALK
	if toggle or (randi() & 1):
		sprite.flip_h = not sprite.flip_h
	anim.play('walk')
	mode_cooldown = randi_range(MIN_WALK_COOLDOWN, MAX_WALK_COOLDOWN)


func _physics_process(delta):
	match mode:
		UnicornMode.STAND:
			velocity.x = 0
			if mode_cooldown <= 0:
				goto_walk_mode(false)
			else:
				mode_cooldown -= delta
		UnicornMode.WALK:
			if is_on_wall():
				sprite.flip_h = get_wall_normal().x > 0.0
			velocity.x = MOVEMENT_SPEED * WALK_MULT
			if not sprite.flip_h:
				velocity.x = -velocity.x
			if mode_cooldown <= 0:
				goto_stand_mode()
			else:
				mode_cooldown -= delta
		UnicornMode.CHARGE:
			if is_on_wall():
				was_on_wall_cooldown = 100.0
				goto_walk_mode(true)
			else:
				velocity.x = MOVEMENT_SPEED * CHARGE_MULT
				if not sprite.flip_h:
					velocity.x = -velocity.x
	if (sprite.flip_h != (global_position.x > player.global_position.x)
			and abs(player.global_position.y - global_position.y) <= VIEW_RAY_WIDTH):
		mode = UnicornMode.CHARGE
	do_physics(delta)
	move_and_slide()
