class_name Board extends Node2D

@export var game_state: GameState

func _ready():
	game_state.player_tile_name_set.connect(_on_player_tile_name_set)
	EventBus.connect("level_initialized", _on_player_tile_name_set)
	for tile in $Tiles.get_children():
		tile.initialize(game_state)

func _on_player_tile_name_set(player_tile_name):
	draw_reachable_tiles(player_tile_name)

func get_tiles_by_state(tile_state: Tile.TileState) -> Array[Tile]:
	var tiles: Array[Tile]
	tiles.assign($Tiles.get_children().filter(
		func(t): return t.tile_state == tile_state
	))
	return tiles

func reset_reachable_tiles():
	for tile in $Tiles.get_children():
		tile.emit_signal("change_can_player_reach", false)

func draw_reachable_tiles(player_tile_name):
	# Reset all tiles to not be reachable. This must happen before setting the new neighbors to
	# be reachable because its previous neighbors need to be updated somehow.
	reset_reachable_tiles()

	var player_tile = $Tiles.get_children().filter(
		func(tile): return tile.name == player_tile_name
	)
	if player_tile.size() == 1:
		print ("updating neighbors of ", player_tile[0].name)
		# Tell all neighbor tiles whether or not they are reachable
		for tile in player_tile[0].get_all_neighbors():
			print (tile.name, " tile_state: ", tile.tile_state)
			tile.emit_signal("change_can_player_reach", tile.tile_state != Tile.TileState.Fire)
