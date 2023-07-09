extends Turn

func play_turn():
	print("Infected's turn")
	game_state.active_turn = game_state.Turn.Infected
	EventBus.emit_signal("turn_changed", "INFECTED")
	
	var tiles_infected: Array[Tile] = board.get_tiles_by_state(Tile.TileState.Infected)
	await get_tree().create_timer(1.0).timeout
	for tile in tiles_infected:
		tile.spread_to_neighbors()

	# Since the infected turn is the last of the round, decrease the count of remaining rounds for
	# the current level.
	game_state.rounds_remaining_for_current_level -= 1
	
	emit_signal("completed")
