class_name Enemy extends CharacterBody2D

@export var life := 50.0
@export var MOVEMENT_SPEED := 10.0
@export var ATTACK_DAMAGE := 10.0
@export var KNOCKBACK_STRENGTH := 800.0
const KNOCKBACK_VECOCITY_SCALING := 0.4
@export var KNOCKBACK_ENVELOPE: float = 0.86
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var knockback = Vector2(0, 0)

@onready var hit_indicator: AnimationPlayer = $HitIndicatorAnimationPlayer
@onready var health_bar: ProgressBar = $HealthBar

func _ready():
	hit_indicator.play('RESET')
	health_bar.max_value = life
	health_bar.value = life

func do_physics(delta):
	if life <= 0:
		i_am_gonna_kill_myself()
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity += knockback
	knockback *= KNOCKBACK_ENVELOPE

func hit_player(player: CharacterBody2D):
	var direction = velocity
	direction.y += 20.0  # So that we don't get rammed into the floor
	direction = direction.normalized() + direction * KNOCKBACK_VECOCITY_SCALING
	player.knockback = direction * KNOCKBACK_STRENGTH
	player.take_damage(ATTACK_DAMAGE)

func take_damage(dmg: int):
	life -= dmg
	health_bar.value = life
	hit_indicator.play('hit')

func i_am_gonna_kill_myself():
	queue_free()
