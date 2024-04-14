extends Area2D

var rooms = [
	"res://scenes/rooms/room_main.tscn",
	"res://scenes/rooms/room1.tscn",
	"res://scenes/rooms/room2.tscn",
]

## Spawn a new room.
func new_room():
	var current_room := get_tree().current_scene.scene_file_path
	var available_rooms = rooms.duplicate()
	# avoid picking the same room again
	available_rooms.erase(current_room)
	var room = available_rooms.pick_random()
	get_tree().call_deferred("change_scene_to_file", room)

func _on_door_body_entered(_body):
	new_room()
