extends TileMap

func _ready():
	print('Cells: ', get_used_cells(0))
	for cell in get_used_cells(0):
		print(cell)
