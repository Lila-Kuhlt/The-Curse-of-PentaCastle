extends CanvasLayer

const CLIP_DISTANCE := 90.0

@onready var image: TextureRect = $Pentagram
@onready var multiline: Line2D = $Multiline

const PENTAGRAM_CORNERS: Array[Vector2] = [
	Vector2(0.5, 1.0),
	Vector2(0.0, 0.65),
	Vector2(0.1, 0.0),
	Vector2(0.9, 0.0),
	Vector2(1.0, 0.65)
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
		for i in PENTAGRAM_CORNERS.size():
			if combo and combo[-1] == i: continue
			var corner := image.position + image.size * image.scale * PENTAGRAM_CORNERS[i]
			if corner.distance_to(event.position) <= CLIP_DISTANCE:
				combo.append(i)
				multiline.add_point(corner)
				break
