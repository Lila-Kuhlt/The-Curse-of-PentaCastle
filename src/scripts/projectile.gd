extends CharacterBody2D

@export var speed := 30.0

var direction: Vector2 = Vector2(1, 0)

func _physics_process(delta: float):
	velocity = direction * speed
	var collision := move_and_collide(velocity * delta)
	if collision:
		print(collision.get_collider())
		queue_free()
