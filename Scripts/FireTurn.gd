extends Turn

func play_turn():
	print("Fire's turn")
	var tiles_on_fire: Array[Tile] = board.get_tiles_by_state(Tile.TileState.Fire)
	await get_tree().create_timer(1.0).timeout
	for tile in tiles_on_fire:
		tile.spread_to_neighbors()
	emit_signal("completed")
