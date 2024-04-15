extends Control

func on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file('res://scenes/world.tscn')

func on_exit_button_pressed() -> void:
	get_tree().quit()
