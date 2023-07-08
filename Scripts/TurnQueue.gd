extends Node

@export var board: Board
@export var game_state: Node

func _ready():
	play_turn()

func play_turn():
	match game_state.active_turn:
		game_state.Turn.Player:
			print("Player's turn")
			pass
		game_state.Turn.Fire:
			print("Eat the fire")
			var tiles_on_fire: Array[Tile] = board.get_tiles_by_state(Tile.TileState.Fire)
			await get_tree().create_timer(1.0).timeout
			for tile in tiles_on_fire:
				tile.spread_to_neighbors()
			play_turn()
			# get all the fire nodes
			
			
			# if there are fire nodes still in the scene
				# call the spread function on them
				# wait for them to be done
				# play turn again
