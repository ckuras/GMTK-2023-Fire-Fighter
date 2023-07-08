extends Turn

func play_turn():
	print("Infected's turn")
	game_state.active_turn = game_state.Turn.Infected
	var tiles_infected: Array[Tile] = board.get_tiles_by_state(Tile.TileState.Infected)
	await get_tree().create_timer(1.0).timeout
	for tile in tiles_infected:
		tile.spread_to_neighbors()
	emit_signal("completed")
