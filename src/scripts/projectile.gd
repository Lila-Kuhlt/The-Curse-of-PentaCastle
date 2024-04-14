class_name Projectile extends CharacterBody2D

@export var speed := 100.0
@export var ATTACK_DAMAGE := 10.0
@export var KNOCKBACK_STRENGTH := 10.0
@export var REMOVE_AFTER := 10.0
var direction: Vector2 = Vector2(1, 0)

func _ready():
	_free_after_time(REMOVE_AFTER)

func _physics_process(delta: float):
	velocity = direction * speed
	var collision := move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider is CharacterBody2D:
			hit_body(collider)
		queue_free()

func hit_body(body: CharacterBody2D):
	body.take_damage(ATTACK_DAMAGE)
	body.knockback = direction.normalized() * KNOCKBACK_STRENGTH

func _free_after_time(wait_time: float):
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = wait_time
	timer.timeout.connect(_timeout_queue_free.bind())
	add_child(timer)
	timer.start()

func _timeout_queue_free():
	queue_free()
