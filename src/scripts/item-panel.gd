extends Panel

@onready var bg: Line2D = $Line2DBG
@onready var fg: Line2D = $Line2DFG

const SCALE := 80.0
const OFFSET := Vector2(-8.0, -8.0)

const PENTAGRAM_CORNERS: Array[Vector2] = [
	Vector2(0.5, 0.885),
	Vector2(0.134, 0.619),
	Vector2(0.273, 0.188),
	Vector2(0.727, 0.188),
	Vector2(0.866, 0.619),
]

func init_lines(line: Array[int]):
	for i in [0, 2, 4, 1, 3, 0, 1, 2, 3, 4, 0]:
		bg.add_point(PENTAGRAM_CORNERS[i] * SCALE + OFFSET)
	for i in line:
		fg.add_point(PENTAGRAM_CORNERS[i] * SCALE + OFFSET)

func _on_mouse_entered() -> void:
	fg.visible = true
	bg.visible = true

func _on_mouse_exited() -> void:
	fg.visible = false
	bg.visible = false

func set_texture(tex: Texture):
	$Margin/TextureRect.texture = tex
