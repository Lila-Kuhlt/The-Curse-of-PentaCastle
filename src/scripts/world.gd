extends Node2D

var rooms = ["res://scenes/room.tscn"]

func new_room():
	var room = rooms.pick_random()
	get_tree().call_deferred("change_scene_to_file", room)

func _on_door_body_entered(_body):
	new_room()
