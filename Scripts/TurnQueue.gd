extends Node

@export var board: Board
@export var game_state: GameState

var active_turn: Turn

func _ready():
	active_turn = get_child(0)
	await game_state.game_state_initialized
	play_active_turn()

func play_active_turn():
	await active_turn.play_turn()
	var new_index: int = (active_turn.get_index() + 1) % get_child_count()
	active_turn = get_child(new_index)
	play_active_turn()
