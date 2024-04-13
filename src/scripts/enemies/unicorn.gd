extends Enemy

enum UnicornMode { CHARGE, STAND, WALK }

const MIN_WALK_COOLDOWN := 100
const MAX_WALK_COOLDOWN := 300
const MIN_STAND_COOLDOWN := 100
const MAX_STAND_COOLDOWN := 400
const WALK_MULT := 0.6
const CHARGE_MULT := 2.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer

var mode := UnicornMode.STAND
var mode_cooldown := 100

func _physics_process(delta):
	match mode:
		UnicornMode.STAND:
			velocity.x = 0
			if mode_cooldown <= 0:
				mode = UnicornMode.WALK
				if randi() & 1:
					sprite.flip_h = not sprite.flip_h
				anim.play('walk')
				mode_cooldown = randi_range(MIN_WALK_COOLDOWN, MAX_WALK_COOLDOWN)
			else:
				mode_cooldown -= delta
		UnicornMode.WALK:
			velocity.x = MOVEMENT_SPEED * WALK_MULT
			if not sprite.flip_h:
				velocity.x = -velocity.x
			if mode_cooldown <= 0:
				mode = UnicornMode.STAND
				anim.play('idle')
				mode_cooldown = randi_range(MIN_STAND_COOLDOWN, MAX_STAND_COOLDOWN)
			else:
				mode_cooldown -= delta
		UnicornMode.CHARGE:
			print('PANIC!')
	do_physics(delta)
	move_and_slide()
