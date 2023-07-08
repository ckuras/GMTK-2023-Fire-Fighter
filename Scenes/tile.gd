extends Sprite2D

enum TileState {
	None,
	Fire,
}
	
@export var state = TileState.None

func _ready(): 
	print("i am a tile: ", tile_state_to_string(state))
	modulate = state_to_modulate(state)
	
func tile_state_to_string(tile_state: TileState):
	match tile_state:
		0: return "None"
		1: return "Fire"

func state_to_modulate(tile_state: TileState):
	match tile_state:
		0: return modulate
		1: return modulate.inverted()
