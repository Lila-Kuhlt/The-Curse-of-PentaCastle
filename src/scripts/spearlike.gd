extends Projectile

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var shape: CollisionShape2D = $CollisionShape2D

const ANIM_TIME := 0.3
const OFFSET := {
	'default': Vector2(4.0, -6.0),
	'spear': Vector2(0.0, -6.0)
}

var time := 0.0
var frame_count: int
var backwards: bool
var anim_time: float

var hitbox_rect: Array[Rect2i] = []

func _ready() -> void:
	var names := anim.sprite_frames.get_animation_names()
	anim.animation = names[randi_range(0, names.size() - 1)]
	anim.frame = 0
	frame_count = anim.sprite_frames.get_frame_count(anim.animation)
	for i in frame_count:
		var tex := anim.sprite_frames.get_frame_texture(anim.animation, i)
		var rect := tex.get_image().get_used_rect()
		rect.position.x = tex.get_width() - rect.position.x - rect.size.x
		hitbox_rect.append(rect)
	backwards = false
	anim_time = ANIM_TIME / float(frame_count)

func _process(delta: float) -> void:
	time += delta
	while time > anim_time:
		time -= anim_time
		if anim.frame >= frame_count - 1:
			backwards = true
		if not backwards: anim.frame += 1
		elif anim.frame == 0: queue_free()
		else: anim.frame -= 1
	shape.shape.size = hitbox_rect[anim.frame].size
	shape.position = shape.shape.size * 0.5 + OFFSET[anim.animation]
