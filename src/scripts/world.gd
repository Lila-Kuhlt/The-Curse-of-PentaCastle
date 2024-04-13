extends Node2D

var rooms = ["res://scenes/world.tscn"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func new_room():
	var room = rooms.pick_random()
	get_tree().change_scene_to_file(room)


func _on_door_body_entered(_body):
	new_room()
