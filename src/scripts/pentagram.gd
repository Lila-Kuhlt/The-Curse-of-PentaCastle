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

var line_length = 0.0

var is_active : bool :
	get:
		return visible

func activate_combo() -> void:
	print('combo: ', combo)
	# reset combo
	combo = []

func calculate_center_position(event: InputEvent):
	return event.position if "position" in event else get_viewport().get_visible_rect().size / 2

func show_pentagram(center_pos):
	visible = true
	image.position = center_pos - image.size * image.scale * 0.5
	multiline.add_point(center_pos)
	multiline.add_point(center_pos)
	line_length = 0

func hide_pentagram():
	visible = false
	multiline.clear_points()
	if combo.size() > 0:
		activate_combo()

func hits_corner(event: InputEvent, i: int):
	if event is InputEventMouseMotion:
		var pos: Vector2 = event.position
		var corner := image.position + image.size * image.scale * PENTAGRAM_CORNERS[i]
		return corner.distance_to(pos) <= CLIP_DISTANCE
	elif event is InputEventJoypadMotion:
		var direction := Input.get_vector("summon_left", "summon_right", "summon_up", "summon_down")
		if not direction: return false
		var angle := direction.angle()
		var corner_angle := (PENTAGRAM_CORNERS[i] - Vector2(0.5, 0.5)).angle()
		return abs(angle_difference(angle, corner_angle)) <= CLIP_ANGLE
	else:
		return false

func calculate_corner_position(i: int):
	return image.position + image.size * image.scale * PENTAGRAM_CORNERS[i]

func get_position_of_event(event: InputEvent):
	if event is InputEventMouseMotion:
		return event.position
	elif event is InputEventJoypadMotion:
		# FIXME: TODO
		return Vector2.ZERO
	else:
		return Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event.is_action("summon") and event.is_pressed() != is_active:
		if event.is_pressed():
			show_pentagram(calculate_center_position(event))
		else:
			hide_pentagram()

	if not is_active:
		return
	if event is InputEventMouseMotion or event is InputEventJoypadMotion:
		multiline.remove_point(multiline.points.size() - 1)

		for i in PENTAGRAM_CORNERS.size():
			if combo and combo[-1] == i: continue
			if hits_corner(event, i):
				combo.append(i)

				var corner_pos = calculate_corner_position(i)
				if combo.size() == 1:
					multiline.remove_point(multiline.points.size() - 1)
				multiline.add_point(corner_pos)
				line_length += multiline.points[multiline.points.size() - 1].distance_to(corner_pos)

				var effect = clip_effect.instantiate()
				effect.position = corner_pos
				effect.emitting = true
				add_child(effect)

				break

		var current_cursor_position = get_position_of_event(event)
		multiline.add_point(current_cursor_position)
		multiline.material.set_shader_parameter('line_length', line_length + multiline.points[multiline.points.size() - 1].distance_to(current_cursor_position))
