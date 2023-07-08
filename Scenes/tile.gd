extends Node2D

enum TileState {
	None,
	Fire,
}

enum Direction {
	NE,
	SE,
	NW,
	SW
}

const TILE_SIZE = Vector2i(32,16)

@export var tile_id = 0
@export var state = TileState.None

@onready var sprite: Sprite2D = $Sprite
@onready var ray_cast: RayCast2D = $RayCast2D

func _ready(): 
	tile_debug()
	sprite.modulate = state_to_modulate(state)
	get_neighbor(Direction.NE)
	
func tile_state_to_string(tile_state: TileState):
	match tile_state:
		0: return "None"
		1: return "Fire"

func state_to_modulate(tile_state: TileState):
	match tile_state:
		0: return sprite.modulate
		1: return sprite.modulate.inverted()

func tile_debug():
	print("Tile ID: ", tile_id)
	print(tile_state_to_string(state))
	print("")

func get_neighbor(direction: Direction):
	match direction:
		Direction.NE:
			ray_cast.target_position = Vector2(16,-8)
			ray_cast.enabled = true
			ray_cast.force_raycast_update()
			var neighbor = ray_cast.get_collider()
			print(neighbor)
			
	
