extends Turn

func play_turn():
	print("Player's turn")
	game_state.active_turn = game_state.Turn.Player
	reset_player_moves_remaining()
	print("going to manually call draw_reachable_item(", game_state.player_tile_id, ")")
	print(game_state)
	board.draw_reachable_tiles(game_state.player_tile_id)
	
	await EventBus.turn_ended
	board.reset_reachable_tiles()
	emit_signal("completed")

func reset_player_moves_remaining():
	game_state.player_moves_remaining = 2
