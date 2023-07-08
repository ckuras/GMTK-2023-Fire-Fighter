class_name Board extends Node2D

@export var game_state: GameState

func _ready():
	game_state.player_tile_id_set.connect(_on_player_tile_id_set)
	for tile in $Tiles.get_children():
		tile.initialize(game_state)

func _on_player_tile_id_set(player_tile_id):
	draw_reachable_tiles(player_tile_id)

func get_tiles_by_state(tile_state: Tile.TileState) -> Array[Tile]:
	var tiles: Array[Tile]
	tiles.assign($Tiles.get_children().filter(
		func(t): return t.tile_state == tile_state
	))
	return tiles

func reset_reachable_tiles():
	for tile in $Tiles.get_children():
		tile.emit_signal("change_can_player_reach", false)

func draw_reachable_tiles(player_tile_id):
	# Reset all tiles to not be reachable. This must happen before setting the new neighbors to
	# be reachable because its previous neighbors need to be updated somehow.
	for tile in $Tiles.get_children():
		tile.emit_signal("change_can_player_reach", false)

	var player_tile = $Tiles.get_children().filter(
		func(tile): return player_tile_id == tile.tile_id 
	)
	if player_tile.size() == 1:
		# Tell all neighbor tiles whether or not they are reachable
		for tile in player_tile[0].get_all_neighbors():
			tile.emit_signal("change_can_player_reach", tile.tile_state == Tile.TileState.None)
