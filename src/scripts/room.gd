extends Node2D

@export var CHESTS := 1
@export var MONSTERS := 1

const Chest = preload("res://scenes/chest.tscn")

func _ready():
	var cells: Array[Vector2i] = $TileMap.get_used_cells(0)
	var chests: Array[Vector2i] = []
	var monsters: Array[Vector2i] = []
	for cell in cells:
		match $TileMap.get_cell_tile_data(0, cell).get_custom_data("name"):
			"chest":
				chests.append(cell)
			"spawner":
				$TileMap.set_cell(0, cell)
				monsters.append(cell)
			_:
				continue
		$TileMap.set_cell(0, cell)

	# chest spawning
	chests.shuffle()
	chests.slice(0, CHESTS)
	for cell in chests:
		var chest := Chest.instantiate()
		chest.position = $TileMap.map_to_local(cell)
		add_child(chest)

	# monster spawning
	monsters.shuffle()
	monsters.slice(0, MONSTERS)
	# TODO

func _process(_delta):
	pass
