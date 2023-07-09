extends Turn

func play_turn():
	print("Player's turn")
	game_state.active_turn = game_state.Turn.Player
	
	reset_player_abilities()
	board.draw_reachable_tiles(game_state.player_tile_name)
	await EventBus.turn_ended

	board.reset_reachable_tiles()
	print("emitting signal completed")
	emit_signal("completed")

func reset_player_abilities():
	reset_player_moves_remaining()
	reset_player_fire_charges_remaining()

func reset_player_moves_remaining():
	game_state.player_moves_remaining = game_state.player_moves_max_for_level

func reset_player_fire_charges_remaining():
	game_state.player_fire_charge_count = game_state.player_fire_charge_max_for_level
