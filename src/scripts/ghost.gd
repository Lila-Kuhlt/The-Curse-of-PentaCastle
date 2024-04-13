extends Node2D

const CHAIN_LEN := 15.0
const ANIMATION_DELTA := 0.8
const FLOATING_SPEED := 5.0
const FLOATING_AMP := 6.0
const OFFSET := Vector2(10.0, -5.0)
const MUL_SPEED := Vector2(0.05, 0.02)
const MAX_SPEED := Vector2(80.0, 30.0)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var frame_count := sprite.sprite_frames.get_frame_count('default')

var ghost_nr : int = 0;  # the nr of the ghost in the chain
var init_frame_nr := false
var init_frame_nr_val := 0
var flipped := false

var t1 := 0.0
var t2 := 0.0

func init(index: int, id: int):
	ghost_nr = index
	init_frame_nr_val = id
	init_frame_nr = true

func _process(delta):
	t1 += delta
	if init_frame_nr:
		sprite.frame = init_frame_nr_val
		init_frame_nr = false
	while t1 >= ANIMATION_DELTA:
		t1 -= ANIMATION_DELTA
		sprite.frame = (sprite.frame + frame_count / 2) % frame_count
	var target := OFFSET + Vector2(CHAIN_LEN * ghost_nr, 0.0)
	t2 += delta
	target.y += sin(t2 * FLOATING_SPEED) * FLOATING_AMP
	if not flipped:
		target.x = -target.x
	var dv := (target - position) * MUL_SPEED
	dv.x = max(min(dv.x, MAX_SPEED.x), -MAX_SPEED.x)
	dv.y = max(min(dv.y, MAX_SPEED.y), -MAX_SPEED.y)
	position += dv
