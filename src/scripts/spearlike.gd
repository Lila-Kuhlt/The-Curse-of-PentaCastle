extends Projectile

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var shape: CollisionShape2D = $CollisionShape2D

const ANIM_TIME := 0.2

var time := 0.0
var frame_count: int
var backwards: bool

var hitbox_rect: Array[Rect2i] = []

func _ready() -> void:
	var names := anim.sprite_frames.get_animation_names()
	anim.animation = names[randi_range(0, names.size() - 1)]
	anim.frame = 0
	frame_count = anim.sprite_frames.get_frame_count(anim.animation)
	for i in frame_count:
		var tex := anim.sprite_frames.get_frame_texture(anim.animation, i)
		hitbox_rect.append(tex.get_image().get_used_rect())
	backwards = false

func _process(delta: float) -> void:
	time += delta
	while time > ANIM_TIME:
		time -= ANIM_TIME
		if anim.frame >= frame_count - 1:
			backwards = true
		if not backwards: anim.frame += 1
		elif anim.frame == 0: queue_free()
		else: anim.frame -= 1
	shape.position = hitbox_rect[anim.frame].position
	shape.shape.size = hitbox_rect[anim.frame].size

func _physics_process(delta: float) -> void:
	pass
