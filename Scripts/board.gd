class_name Board extends Node2D


func get_tiles_by_state(tile_state: Tile.TileState) -> Array[Tile]:
	var tiles: Array[Tile]
	tiles.assign($Tiles.get_children().filter(
		func(t): return t.state == tile_state
	))
	return tiles
