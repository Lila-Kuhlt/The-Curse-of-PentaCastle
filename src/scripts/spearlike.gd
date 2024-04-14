extends Projectile

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var shape: CollisionShape2D = $CollisionShape2D

const ANIM_TIME := 0.2
const OFFSET := Vector2(4.0, -6.0)

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
		var rect := tex.get_image().get_used_rect()
		rect.position.x = tex.get_width() - rect.position.x - rect.size.x
		hitbox_rect.append(rect)
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
	shape.position = Vector2(hitbox_rect[anim.frame].position) + OFFSET
	shape.shape.size = hitbox_rect[anim.frame].size

func _physics_process(delta: float) -> void:
	pass
