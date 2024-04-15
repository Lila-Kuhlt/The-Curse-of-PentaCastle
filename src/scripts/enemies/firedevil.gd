extends Enemy

enum FiredevilMode { CHARGE, CHARGE_START, WALK }

const MIN_WALK_COOLDOWN := 100
const MAX_WALK_COOLDOWN := 300
const MIN_STAND_COOLDOWN := 30
const MAX_STAND_COOLDOWN := 200
const CHARGE_COOLDOWN := 50
const WALK_MULT := 0.6
const CHARGE_MULT := 7.0
const VIEW_RAY_WIDTH := 5.0

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

var mode := FiredevilMode.WALK
var mode_cooldown := 100
var was_on_wall_cooldown := 0.0

func goto_walk_mode(toggle: bool):
	mode = FiredevilMode.WALK
	if toggle or (randi() & 1):
		_flip_direction()
	anim.play('walk')
	mode_cooldown = randi_range(MIN_WALK_COOLDOWN, MAX_WALK_COOLDOWN)

func _physics_process(delta):
	# player detection
	var collider = $ViewRay.get_collider()
	if collider == get_tree().get_first_node_in_group("player"):
		if mode != FiredevilMode.CHARGE_START and mode != FiredevilMode.CHARGE:
			mode = FiredevilMode.CHARGE_START
			mode_cooldown = CHARGE_COOLDOWN
			anim.play('walk')

	if is_on_floor() and !$GroundRay.is_colliding():
		# about to fall down
		goto_walk_mode(true)

	match mode:
		FiredevilMode.WALK:
			if is_on_wall():
				is_facing_right = get_wall_normal().x > 0.0
			velocity.x = MOVEMENT_SPEED * WALK_MULT
			if not is_facing_right:
				velocity.x = -velocity.x
			if mode_cooldown <= 0:
				goto_walk_mode(true)
			else:
				mode_cooldown -= delta
		FiredevilMode.CHARGE_START:
			mode_cooldown -= delta
			if mode_cooldown <= 0:
				mode = FiredevilMode.CHARGE
				anim.play('walk')
		FiredevilMode.CHARGE:
			if is_on_wall() and (get_wall_normal().x > 0.0) != is_facing_right:
				was_on_wall_cooldown = 100.0
				goto_walk_mode(true)
			else:
				velocity.x = MOVEMENT_SPEED * CHARGE_MULT
				if not is_facing_right:
					velocity.x = -velocity.x

	do_physics(delta)
	move_and_slide()

func _on_hit_collider_body_entered(body):
	hit_player(body)
