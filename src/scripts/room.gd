extends Node2D

@export var MONSTERS := 1

const Chest = preload("res://scenes/chest.tscn")

func _ready():
	$Door.disable()
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
	var spell = get_tree().get_first_node_in_group("world").get_next_spell()
	if spell != SpellBook.Spells.PLACEHOLDER and not chests.is_empty():
		chests.shuffle()
		var cell = chests.pick_random()
		var chest := Chest.instantiate()
		chest.spell = spell
		chest.position = $Map.map_to_local(cell)
		add_child(chest)

	# monster spawning
	monsters.shuffle()
	monsters.slice(0, MONSTERS)
	# TODO

func room_cleared():
	$Door.enable()
