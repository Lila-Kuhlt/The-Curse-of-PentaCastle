class_name Enemy extends CharacterBody2D

const SPIKE_DAMAGE_COOLDOWN = 0.7
const SPIKE_DAMAGE := 10

@export var score: int = 10
@export var life := 50.0
@export var MOVEMENT_SPEED := 10.0
@export var ATTACK_DAMAGE := 10.0
@export var KNOCKBACK_STRENGTH := 800.0
const KNOCKBACK_VELOCITY_SCALING := 0.4
@export var KNOCKBACK_ENVELOPE: float = 0.977
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var knockback = Vector2(0, 0)
var damage_multiplier = 1.0
var spike_damage_timer: float = 0
var colliding_spike := false

@onready var hit_indicator: AnimationPlayer = $HitIndicatorAnimationPlayer
@onready var health_bar: ProgressBar = $HealthBar
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_facing_right := false:
	set(value):
		if is_facing_right != value:
			_flip_direction()
			is_facing_right = value

func _flip_direction():
	for node in [sprite, $HitCollider, $SpikeCollider, $GroundRay, $ViewRay]:
		node.scale.x *= -1
		node.position.x *= -1

func flip_direction():
	is_facing_right = not is_facing_right

func _ready():
	hit_indicator.play('RESET')
	health_bar.max_value = life
	health_bar.value = life

func _physics_process(delta: float):
	on_obstacle(flip_direction)
	if is_on_wall():
		is_facing_right = get_wall_normal().x > 0.0
	velocity.x = MOVEMENT_SPEED
	if not is_facing_right:
		velocity.x = -velocity.x

	do_physics(delta)
	move_and_slide()

func on_obstacle(callback: Callable):
	var collider = $GroundRay.get_collider()
	if is_on_floor() and not collider:
		# about to fall down
		callback.call()
	elif collider is TileMap:
		var cell = collider.local_to_map($GroundRay.get_collision_point())
		if collider.get_cell_tile_data(0, cell).get_custom_data("name") == "spike":
			# about to fall into spikes
			callback.call()

func do_physics(delta: float):
	if life <= 0:
		i_am_gonna_kill_myself()
	velocity.y += gravity * delta
	velocity += knockback
	knockback *= KNOCKBACK_ENVELOPE

	spike_damage_timer = max(spike_damage_timer - delta, 0.0)
	if colliding_spike and not spike_damage_timer:
		take_damage(SPIKE_DAMAGE)
		spike_damage_timer = SPIKE_DAMAGE_COOLDOWN

func hit_player(player: CharacterBody2D):
	var direction = velocity
	direction = direction.normalized() + direction * KNOCKBACK_VELOCITY_SCALING
	player.knockback = direction * KNOCKBACK_STRENGTH
	player.take_damage(ATTACK_DAMAGE)

func take_damage(dmg: int):
	life -= dmg * damage_multiplier
	health_bar.value = life
	hit_indicator.play('hit')

func i_am_gonna_kill_myself():
	var world = get_tree().get_first_node_in_group("world")
	world.add_score(score)
	world.check_room_cleared()
	queue_free()


func _on_hit_collider_body_entered(body):
	pass # Replace with function body.

func _on_spike_collider_body_entered(body: Node2D) -> void:
	if body is TileMap: colliding_spike = true

func _on_spike_collider_body_exited(body: Node2D) -> void:
	if body is TileMap: colliding_spike = false
