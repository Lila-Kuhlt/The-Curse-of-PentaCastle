class_name Projectile extends CharacterBody2D

@export var speed := 100.0
@export var ATTACK_DAMAGE := 10.0
@export var KNOCKBACK_STRENGTH := 10.0
@export var REMOVE_AFTER := 10.0
@export var PIERCING := false
@export var IS_FISH := false
var direction: Vector2 = Vector2(1, 0)
var fish_timer := 0.0
const FISH_FREQ := 12.0
const FISH_AMP := 250.0

func _ready():
	_free_after_time(REMOVE_AFTER)

func set_flipped(val: bool) -> void:
	$CollisionShape2D.scale.x = -1 if val else 1
	if val:
		$CollisionShape2D.position.x = -$CollisionShape2D.position.x
	$AnimatedSprite2D.flip_h = val

func _physics_process(delta: float):
	velocity = direction * speed
	if IS_FISH:
		velocity.y += cos(fish_timer * FISH_FREQ) * FISH_AMP
		fish_timer += delta
	var collision := move_and_collide(velocity * delta, true)
	position += velocity * delta
	if collision:
		var collider = collision.get_collider()
		if collider is CharacterBody2D:
			hit_body(collider)
		if not PIERCING:
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
