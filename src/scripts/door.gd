extends Area2D

var rooms = [
	"res://scenes/rooms/room_main.tscn",
	"res://scenes/rooms/room1.tscn",
]

## Spawn a new room.
func new_room():
	var room = rooms.pick_random()
	get_tree().call_deferred("change_scene_to_file", room)

func _on_door_body_entered(_body):
	new_room()
