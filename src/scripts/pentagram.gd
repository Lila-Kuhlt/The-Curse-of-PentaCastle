extends CanvasLayer

const SUPPORT_CONTROLLERS := false
const CLIP_DISTANCE := 90.0
const CLIP_ANGLE := 0.5

@onready var image: TextureRect = $Pentagram
@onready var multiline: Line2D = $Multiline

const clip_effect = preload("res://scenes/clip_particles_effect.tscn")

const PENTAGRAM_CORNERS: Array[Vector2] = [
	Vector2(0.5, 0.885),
	Vector2(0.134, 0.619),
	Vector2(0.273, 0.188),
	Vector2(0.727, 0.188),
	Vector2(0.866, 0.619),
]

var combo: Array[int] = []

signal combo_done(combo: Array[int])

var is_active : bool :
	get:
		return visible

func activate_combo() -> void:
	combo_done.emit(combo)
	combo = []

func center_position() -> Vector2:
	return get_viewport().get_visible_rect().size / 2

func show_pentagram():
	visible = true
	image.position = center_position() - image.size * image.scale * 0.5

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
		var joystick_input := Input.get_vector("summon_left", "summon_right", "summon_up", "summon_down", 0.0)
		var pentagram_center = image.position + image.size * image.scale * 0.5
		return pentagram_center + joystick_input * image.size * 0.5
	else:
		return Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event.is_action("summon") and event.is_pressed() != is_active:
		if event.is_pressed():
			show_pentagram()
			var start_pos = event.position if "position" in event else center_position()
			multiline.add_point(start_pos)
		else:
			hide_pentagram()

	if not is_active:
		return
	if event is InputEventMouseMotion or (event is InputEventJoypadMotion and SUPPORT_CONTROLLERS):
		for i in PENTAGRAM_CORNERS.size():
			if combo and combo[-1] == i: continue
			if hits_corner(event, i):
				SfxAudio.play_sfx(SfxAudio.Sound.DRAW_SHORT)
				for _i in range(multiline.points.size() - combo.size()):
					multiline.remove_point(combo.size())

				combo.append(i)

				var corner_pos = calculate_corner_position(i)
				multiline.add_point(corner_pos)

				var effect = clip_effect.instantiate()
				effect.position = corner_pos
				effect.emitting = true
				add_child(effect)

				break

		var current_cursor_position = get_position_of_event(event)
		multiline.add_point(current_cursor_position)

		var line_length = 0.0
		for i in range(multiline.get_point_count() - 1):
			line_length += multiline.get_point_position(i).distance_to(multiline.get_point_position(i + 1))
		multiline.material.set_shader_parameter('line_length', line_length)
