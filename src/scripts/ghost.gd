extends Node2D

const ANIMATION_DELTA := 0.8
const FLOATING_SPEED := 5.0
const FLOATING_AMP := 6.0
const MUL_SPEED := Vector2(0.05, 0.02)
const MAX_SPEED := Vector2(80.0, 30.0)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var frame_count := sprite.sprite_frames.get_frame_count('default')

@export var target: Vector2 = Vector2.ZERO
var init_frame_nr_val := 0

var t1 := 0.0
var t2 := 0.0

func init(spell: SpellBook.Spells):
	init_frame_nr_val = spell

func _ready() -> void:
	sprite.frame = init_frame_nr_val
	particles.texture.region.position.x = init_frame_nr_val * 8.0

func _process(delta):
	t1 += delta
	while t1 >= ANIMATION_DELTA:
		t1 -= ANIMATION_DELTA
		sprite.frame = (sprite.frame + (frame_count >> 1)) % frame_count
	t2 += delta

	var current_target := target
	current_target.y += sin(t2 * FLOATING_SPEED) * FLOATING_AMP
	var dv := (current_target - position) * MUL_SPEED
	dv.x = max(min(dv.x, MAX_SPEED.x), -MAX_SPEED.x)
	dv.y = max(min(dv.y, MAX_SPEED.y), -MAX_SPEED.y)
	position += dv
