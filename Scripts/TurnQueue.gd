extends Node

enum Turn {
	Fire,
}

@export var board: Board
var active_turn = Turn.Fire

func play_turn():
	match active_turn:
		Turn.Fire:
			# get all the fire nodes
			
			
			# if there are fire nodes still in the scene
				# call the spread function on them
				# wait for them to be done
				# play turn again
