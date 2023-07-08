extends Turn

func play_turn():
	print("Player's turn")
	emit_signal("completed")
