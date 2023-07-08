class_name Tile extends Node2D

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
	print(get_neighbors())
	
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

func get_neighbors() -> Array[Tile]:
	return [
		get_neighbor_by_direction(Direction.NE),
		get_neighbor_by_direction(Direction.NW),
		get_neighbor_by_direction(Direction.SE),
		get_neighbor_by_direction(Direction.SW)
	]

func get_neighbor_by_direction(direction: Direction):
	ray_cast.target_position = get_target_by_direction(direction)
	ray_cast.force_raycast_update()
	return ray_cast.get_collider()

func get_target_by_direction(direction: Direction):
	match direction:
		Direction.NE:
			return Vector2(16,-8)
		Direction.NW:
			return Vector2(-16, -8)	
		Direction.SE:
			return Vector2(16, 8)
		Direction.SW:
			return Vector2(-16, 8)	
	
