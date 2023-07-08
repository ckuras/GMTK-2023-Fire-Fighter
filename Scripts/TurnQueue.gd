extends Node

@export var board: Board
@export var game_state: GameState

func _ready():
	game_state.active_turn = game_state.Turn.Infected
	play_turn()

func play_turn():
	match game_state.active_turn:
		game_state.Turn.Player:
			print("Player's turn")
			pass
		game_state.Turn.Fire:
			print("Fire's turn")
			var tiles_on_fire: Array[Tile] = board.get_tiles_by_state(Tile.TileState.Fire)
			await get_tree().create_timer(1.0).timeout
			for tile in tiles_on_fire:
				tile.spread_to_neighbors()
			game_state.active_turn = game_state.Turn.Infected
			play_turn()
		game_state.Turn.Infected:
			print("Infected's turn")
			var tiles_on_fire: Array[Tile] = board.get_tiles_by_state(Tile.TileState.Infected)
			await get_tree().create_timer(1.0).timeout
			for tile in tiles_on_fire:
				tile.spread_to_neighbors()
			game_state.active_turn = game_state.Turn.Fire
			play_turn()
			
