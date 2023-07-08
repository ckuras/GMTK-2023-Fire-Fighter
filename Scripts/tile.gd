class_name Tile extends Node2D

signal change_tile_state(state: Tile.TileState)
signal change_can_player_reach(reachable: bool)

enum TileState {
	None,
	Fire,
	Infected
}

enum Direction {
	N,
	E,
	S,
	W,
	NE,
	SE,
	NW,
	SW
}

const TILE_SIZE = Vector2i(32,16)

@export var can_player_reach = false
@export var has_player = false
@export var tile_id: int
@export var tile_state = TileState.None

@onready var sprite: Sprite2D = $Sprite
@onready var ray_cast: RayCast2D = $RayCast2D

var game_state: GameState

func initialize(_game_state: GameState):
	game_state = _game_state
	game_state.player_tile_id_set.connect(_on_player_tile_id_set)

func _ready(): 
	change_tile_state.connect(_on_state_change)
	change_can_player_reach.connect(_on_can_player_reach_change)
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
		2: modulate = Color.WEB_PURPLE

func _on_can_player_reach_change(_can_player_reach):
	can_player_reach = _can_player_reach
	if can_player_reach:
		$Reachable.show()
	else:
		$Reachable.hide()

func _on_player_tile_id_set(player_tile_id):
	# If player is on this tile
	if player_tile_id == tile_id:
		# Update our state to know that we have the player
		has_player = true
		
		# Visually display the player sprite
		$Player.show()
		
		# Reset all tiles to not be reachable. This must happen before setting the new neighbors to
		# be reachable because its previous neighbors need to be updated somehow.
		for tile in get_parent().get_children():
			tile.emit_signal("change_can_player_reach", false)
		
		# Tell all neighbor tiles whether or not they are reachable
		for tile in get_all_neighbors():
			tile.emit_signal("change_can_player_reach", tile.tile_state == TileState.None)
		
	else:
		# Update our state to know that we no longer have the player
		has_player = false
		
		# Visually hide the player sprite
		$Player.hide()	

func get_all_neighbors_include_nulls() -> Array[Tile]:
	return [
		get_neighbor_by_direction(Direction.N),
		get_neighbor_by_direction(Direction.E),
		get_neighbor_by_direction(Direction.S),
		get_neighbor_by_direction(Direction.W),
		get_neighbor_by_direction(Direction.NE),
		get_neighbor_by_direction(Direction.NW),
		get_neighbor_by_direction(Direction.SE),
		get_neighbor_by_direction(Direction.SW)
	]

func get_cardinal_neighbors_include_nulls() -> Array[Tile]:
	return [
		get_neighbor_by_direction(Direction.NE),
		get_neighbor_by_direction(Direction.NW),
		get_neighbor_by_direction(Direction.SE),
		get_neighbor_by_direction(Direction.SW)
	]

func get_all_neighbors() -> Array[Tile]:
	var not_null_neighbors: Array[Tile]
	not_null_neighbors.assign(get_all_neighbors_include_nulls().filter(
		func(n): return n != null
	))
	return not_null_neighbors

func get_cardinal_neighbors():
	var not_null_neighbors: Array[Tile]
	not_null_neighbors.assign(get_cardinal_neighbors_include_nulls().filter(
		func(n): return n != null
	))
	return not_null_neighbors

func get_neighbor_by_direction(direction: Direction):
	ray_cast.target_position = get_target_by_direction(direction)
	print("casting ray ", direction, " to ", get_target_by_direction(direction))
	ray_cast.force_raycast_update()
	if ray_cast.get_collider() != null:
		print("hit ", ray_cast.get_collider().tile_id)
	return ray_cast.get_collider()

func get_target_by_direction(direction: Direction):
	match direction:
		Direction.N:
			return Vector2(0, -16)
		Direction.E:
			return Vector2(32, 0)
		Direction.S:
			return Vector2(0, 16)
		Direction.W:
			return Vector2(-32, 0)
		Direction.NE:
			return Vector2(16, -8)
		Direction.NW:
			return Vector2(-16, -8)	
		Direction.SE:
			return Vector2(16, 8)
		Direction.SW:
			return Vector2(-16, 8)	

func spread_to_neighbors():
	var neighbors: Array[Tile] = get_cardinal_neighbors()
	for tile in neighbors:
		if tile.tile_state != TileState.Fire:
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
			if can_player_reach and !previous_clicked and event.is_pressed():
				previous_clicked = true
				game_state.player_tile_id = tile_id
				EventBus.emit_signal("turn_ended")
			if previous_clicked and !event.is_pressed():
				previous_clicked = false
