class_name Board extends Node2D

@export var game_state: Node

func _ready():
	for tile in $Tiles.get_children():
		tile.initialize(game_state)

func get_tiles_by_state(tile_state: Tile.TileState) -> Array[Tile]:
	var tiles: Array[Tile]
	tiles.assign($Tiles.get_children().filter(
		func(t): return t.state == tile_state
	))
	return tiles
