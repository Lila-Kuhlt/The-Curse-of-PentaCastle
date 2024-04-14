extends CharacterBody2D

@export var speed := 60.0
@export var ATTACK_DAMAGE := 10.0
@export var KNOCKBACK_STRENGTH := 30.0
var direction: Vector2 = Vector2(1, 0)

func _physics_process(delta: float):
	velocity = direction * speed
	var collision := move_and_collide(velocity * delta)
	if collision:
		print(collision.get_collider())
		hit_body(collision.get_collider())
		queue_free()

func hit_body(body: CharacterBody2D):
	body.LIFE -= ATTACK_DAMAGE
	body.knockback = direction.normalized() * KNOCKBACK_STRENGTH
