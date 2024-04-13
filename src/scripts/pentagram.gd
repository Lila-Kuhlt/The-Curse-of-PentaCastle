extends CanvasLayer

const CLIP_DISTANCE := 90.0

@onready var image: TextureRect = $Pentagram
@onready var multiline: Line2D = $Multiline

@onready var clip_effect = preload("res://scenes/clip_particles_effect.tscn")

const PENTAGRAM_CORNERS: Array[Vector2] = [
	Vector2(0.5, 0.885),
	Vector2(0.134, 0.619),
	Vector2(0.273, 0.188),
	Vector2(0.727, 0.188),
	Vector2(0.866, 0.619),
]

var combo: Array[int] = []

var is_drawing := false

func activate_combo() -> void:
	print('combo: ', combo)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		image.position = event.position - image.size * image.scale * 0.5
		is_drawing = event.is_pressed()
		if not is_drawing:
			multiline.clear_points()
			if combo:
				activate_combo()
			combo = []
		image.visible = is_drawing
	if event is InputEventMouseMotion and is_drawing:
		var pos: Vector2 = event.position
		for i in PENTAGRAM_CORNERS.size():
			if combo and combo[-1] == i: continue
			var corner := image.position + image.size * image.scale * PENTAGRAM_CORNERS[i]
			if corner.distance_to(pos) <= CLIP_DISTANCE:
				while multiline.points.size() > combo.size():
					multiline.remove_point(multiline.points.size() - 1)
				combo.append(i)
				pos = corner
				var effect = clip_effect.instantiate()
				effect.position = pos
				effect.emitting = true
				add_child(effect)
				break
		multiline.add_point(pos)
