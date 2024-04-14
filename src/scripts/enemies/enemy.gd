class_name Enemy extends CharacterBody2D

@export var LIFE := 50.0
@export var MOVEMENT_SPEED := 10.0
@export var ATTACK_DAMAGE := 10.0
@export var KNOCKBACK_STRENGTH := 40.0
@export var KNOCKBACK_ENVELOPE: float = 0.86
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var knockback = Vector2(0, 0)

func do_physics(delta):
	if LIFE <= 0:
		i_am_gonna_kill_myself()
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity += knockback
	knockback *= KNOCKBACK_ENVELOPE


func hit_player(player: CharacterBody2D):
	player.LIFE -= ATTACK_DAMAGE
	var direction = (-player.velocity).normalized()
	player.knockback = direction * KNOCKBACK_STRENGTH
	print(player.LIFE)

func i_am_gonna_kill_myself():
	queue_free()
