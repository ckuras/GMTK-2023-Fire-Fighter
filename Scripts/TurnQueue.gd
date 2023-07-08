extends Node

enum Turn {
	Fire,
}

@export var board: Board
var active_turn = Turn.Fire

func _ready():
	play_turn()

func play_turn():
	match active_turn:
		Turn.Fire:
			var tiles_on_fire: Array[Tile] = board.get_tiles_by_state(Tile.TileState.Fire)
			for tile in tiles_on_fire:
				print('this tile is on fire: ', tile)
			# get all the fire nodes
			
			
			# if there are fire nodes still in the scene
				# call the spread function on them
				# wait for them to be done
				# play turn again
