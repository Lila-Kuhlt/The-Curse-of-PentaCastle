extends Node2D

@export var CHESTS := 1
@export var MONSTERS := 1

const Chest = preload("res://scenes/chest.tscn")

var rooms = ["res://scenes/room.tscn"]

func _ready():
	var cells: Array[Vector2i] = $Map.get_used_cells(0)
	var chests: Array[Vector2i] = []
	var monsters: Array[Vector2i] = []
	for cell in cells:
		match $Map.get_cell_tile_data(0, cell).get_custom_data("name"):
			"chest":
				chests.append(cell)
			"spawner":
				$Map.set_cell(0, cell)
				monsters.append(cell)
			_:
				continue
		$Map.set_cell(0, cell)

	# chest spawning
	chests.shuffle()
	chests = chests.slice(0, CHESTS)
	for cell in chests:
		var chest := Chest.instantiate()
		chest.position = $Map.map_to_local(cell)
		add_child(chest)

	# monster spawning
	monsters.shuffle()
	monsters.slice(0, MONSTERS)
	# TODO

## Spawn a new room.
func new_room():
	var room = rooms.pick_random()
	get_tree().call_deferred("change_scene_to_file", room)

func _on_door_body_entered(_body):
	new_room()
