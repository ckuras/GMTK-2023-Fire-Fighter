extends Turn

func play_turn():
	print("Player's turn")
	game_state.active_turn = game_state.Turn.Player
	reset_player_moves_remaining()
	
	await EventBus.turn_ended
	emit_signal("completed")

func reset_player_moves_remaining():
	game_state.player_moves_remaining = 2
