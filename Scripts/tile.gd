class_name Tile extends Node2D

signal change_tile_state(state: Tile.TileState)

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

@export var has_player = false
@export var tile_id = 0
@export var tile_state = TileState.None

@onready var sprite: Sprite2D = $Sprite
@onready var ray_cast: RayCast2D = $RayCast2D

var game_state: Node

func initialize(_game_state: Node):
	game_state = _game_state
	game_state.player_tile_id_set.connect(_on_player_tile_id_set)

func _ready(): 
	change_tile_state.connect(_on_state_change)
	emit_signal("change_tile_state", tile_state)

func tile_state_to_string(tile_state: TileState):
	match tile_state:
		0: return "None"
		1: return "Fire"

func _on_state_change(_tile_state: TileState):
	tile_state = _tile_state
	match tile_state:
		0: pass
		1: modulate = Color.RED

func _on_player_tile_id_set(player_tile_id):
	if player_tile_id == tile_id:
		has_player = true
		$Player.show()
	else:
		has_player = false
		$Player.hide()

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
		tile.emit_signal("change_tile_state", tile_state)

# --- Mouse events and state ---

var previous_clicked = false
var mouse_over = false

func _on_mouse_entered():
	mouse_over = true
	if game_state.active_turn == game_state.Turn.Player:
		$Hover.show()

func _on_mouse_exited():
	mouse_over = false
	if game_state.active_turn == game_state.Turn.Player:
		$Hover.hide()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if mouse_over and event.button_index == MOUSE_BUTTON_LEFT:
			if !previous_clicked and event.is_pressed():
				previous_clicked = true
				game_state.player_tile_id = tile_id
			if previous_clicked and !event.is_pressed():
				previous_clicked = false
