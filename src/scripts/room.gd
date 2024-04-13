extends Node2D

func _ready():
	var cells = $TileMap.get_used_cells(0)
	for cell in cells:
		match $TileMap.get_cell_tile_data(0, cell).get_custom_data("name"):
			"chest":
				$TileMap.set_cell(0, cell)
			"spawner":
				$TileMap.set_cell(0, cell)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
