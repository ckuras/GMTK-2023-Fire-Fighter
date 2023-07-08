class_name Board extends Node2D

func _ready():
	print("the fires amirite fellas")
	print(get_tiles_by_state(Tile.TileState.Fire))

func get_tiles_by_state(tile_state: Tile.TileState):
	return $Tiles.get_children().filter(
		func(t): return t.state == tile_state
	)
