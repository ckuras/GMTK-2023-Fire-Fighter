class_name Board extends Node2D

@export var game_state: GameState

func _ready():
	for tile in $Tiles.get_children():
		tile.initialize(game_state)

func get_tiles_by_state(tile_state: Tile.TileState) -> Array[Tile]:
	var tiles: Array[Tile]
	tiles.assign($Tiles.get_children().filter(
		func(t): return t.tile_state == tile_state
	))
	return tiles
