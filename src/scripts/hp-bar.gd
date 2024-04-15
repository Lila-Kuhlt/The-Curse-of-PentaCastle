extends Panel

var max_value: int = 100;
@onready var label: Label = $Label

func set_max_value(max_val: int) -> void:
	max_value = max_val

func set_value(val: int) -> void:
	material.set_shader_parameter('value', float(val) / float(max_value))
	# haha fuck margins, go fuck yourself godot
	label.text = "    " + str(val)

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.life_changed.connect(set_value)
	set_value(player.life)
