extends Turn

func play_turn():
	print("Player's turn")
	await EventBus.turn_ended
	emit_signal("completed")
