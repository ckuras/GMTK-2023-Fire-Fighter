class_name Tile extends Node2D

signal change_state(state: Tile.TileState)

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

@export var has_player = false : set = _set_has_player

func _set_has_player(_has_player):
	has_player = _has_player
	if has_player:
		$Player.show()
	else:
		$Player.hide() 

@export var tile_id = 0
@export var state = TileState.None

@onready var sprite: Sprite2D = $Sprite
@onready var ray_cast: RayCast2D = $RayCast2D

func _ready(): 
	change_state.connect(_on_state_change)
	emit_signal("change_state", state)
	
func tile_state_to_string(tile_state: TileState):
	match tile_state:
		0: return "None"
		1: return "Fire"

func _on_state_change(tile_state: TileState):
	state = tile_state
	match tile_state:
		0: pass
		1: modulate = Color.RED

func get_neighbors_include_nulls() -> Array[Tile]:
	return [
		get_neighbor_by_direction(Direction.NE),
		get_neighbor_by_direction(Direction.NW),
		get_neighbor_by_direction(Direction.SE),
		get_neighbor_by_direction(Direction.SW)
	]

func get_neighbors():
	var not_null_neighbors: Array[Tile]
	not_null_neighbors.assign(get_neighbors_include_nulls().filter(
		func(t): return t != null
	))
	return not_null_neighbors

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

func spread_to_neighbors():
	var neighbors: Array[Tile] = get_neighbors()
	for tile in neighbors:
		tile.emit_signal("change_state", state)
