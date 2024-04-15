extends Control

@onready var _score_container = $CenterContainer/VBoxContainer/VBoxContainer/Score

var score: int

func _ready() -> void:
	_score_container.text = str(score)


func _on_restart_button_pressed() -> void:
	var tree = get_tree()
	tree.reload_current_scene()
	tree.paused = false
