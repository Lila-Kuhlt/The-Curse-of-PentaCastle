extends CanvasLayer

const CLIP_DISTANCE := 90.0
const CLIP_ANGLE := 0.5

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
var line_length := 0.0

func activate_combo() -> void:
	print('combo: ', combo)
	# reset combo
	combo = []

func _input(event: InputEvent) -> void:
	if event.is_action("summon"):
		var pos = event.position if "position" in event else get_viewport().get_visible_rect().size / 2
		image.position = pos - image.size * image.scale * 0.5
		is_drawing = event.is_pressed()
		if not is_drawing:
			multiline.clear_points()
			if combo:
				activate_combo()
		image.visible = is_drawing
	if event is InputEventMouseMotion and is_drawing:
		var pos: Vector2 = event.position
		for i in PENTAGRAM_CORNERS.size():
			if combo and combo[-1] == i: continue
			var corner := image.position + image.size * image.scale * PENTAGRAM_CORNERS[i]
			if corner.distance_to(pos) <= CLIP_DISTANCE:
				while multiline.points.size() > combo.size():
					multiline.remove_point(multiline.points.size() - 1)
				line_length = 0.0
				for j in range(multiline.points.size() - 1):
					line_length += multiline.points[j].distance_to(multiline.points[j + 1])
				combo.append(i)
				pos = corner
				var effect = clip_effect.instantiate()
				effect.position = pos
				effect.emitting = true
				add_child(effect)
				break
		if multiline.points.size():
			line_length += pos.distance_to(multiline.points[multiline.points.size() - 1])
		multiline.add_point(pos)
		multiline.material.set_shader_parameter('line_length', line_length)
	if event is InputEventJoypadMotion and is_drawing:
		var direction := Input.get_vector("summon_left", "summon_right", "summon_up", "summon_down")
		if not direction: return
		var angle := direction.angle()
		for i in PENTAGRAM_CORNERS.size():
			if combo and combo[-1] == i: continue
			var corner_angle := (PENTAGRAM_CORNERS[i] - Vector2(0.5, 0.5)).angle()
			if abs(angle_difference(angle, corner_angle)) <= CLIP_ANGLE:
				combo.append(i)
				var pos := image.position + image.size * image.scale * PENTAGRAM_CORNERS[i]
				var effect = clip_effect.instantiate()
				effect.position = pos
				effect.emitting = true
				add_child(effect)
				multiline.add_point(pos)
				multiline.material.set_shader_parameter('line_length', line_length)
				break
