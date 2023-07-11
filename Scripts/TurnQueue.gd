extends Node

@export var board: Board
@export var game_state: GameState

var active_turn: Turn

func _ready():
	active_turn = get_child(0)
	# await EventBus.level_initialized
	play_active_turn()

func play_active_turn():
	await active_turn.play_turn()
	var new_index: int = (active_turn.get_index() + 1) % get_child_count()
	active_turn = get_child(new_index)
	
	if did_player_win():
		print("Player won, we should tell them")
		await get_tree().create_timer(0.1).timeout
		EventBus.emit_signal("player_won_round")
	elif did_player_lose():
		print("Player lost, we should tell them to restart")
		await get_tree().create_timer(0.1).timeout
		EventBus.emit_signal("player_lost_round")
	else:
		print("Didn't win, didn't lose, keep it rolling")
		play_active_turn()


func did_player_win() -> bool:
	return (
		are_there_no_more_infected_tiles() and
		!is_player_in_fire_tile() and 
		!is_player_in_infected_tile()
	)
	
func did_player_lose() -> bool:
	return (
		is_player_out_of_turns() or
		is_player_in_fire_tile() or 
		is_player_in_infected_tile()
	)
	
func are_there_no_more_infected_tiles():
	print("Checking if there are any infected tiles left")
	var tiles = board.get_child(0).get_children()
	return !tiles.any(func(t: Tile): return t.tile_state == Tile.TileState.Infected)
	
func is_player_out_of_turns() -> bool:
	print("Checking if the player is out of turns...")
	print("Turns remaining: ", game_state.rounds_remaining_for_current_level)
	return game_state.rounds_remaining_for_current_level <= 0

func is_player_in_fire_tile() -> bool:
	return is_player_in_tile_state(Tile.TileState.Fire)
	
func is_player_in_infected_tile() -> bool:
	return is_player_in_tile_state(Tile.TileState.Infected)
	
func is_player_in_tile_state(tile_state: Tile.TileState) -> bool:
	var tiles = board.get_child(0).get_children()
	var array_with_just_player_tile = tiles.filter(func(t: Tile): return t.has_player)
	if (array_with_just_player_tile.size() != 1):
		print("Can't find the tile with the player. Start panicking...return false I guess?")
		return false
	else:
		var player_tile = array_with_just_player_tile[0]
		print("player in ", tile_state, "? ", player_tile.tile_state == tile_state)
		return player_tile.tile_state == tile_state
