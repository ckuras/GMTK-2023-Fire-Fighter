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

@export var can_player_reach = false
@export var has_player: bool
@export var tile_state = TileState.None

@onready var sprite: Sprite2D = $Sprite
@onready var ray_cast: RayCast2D = $RayCast2D

var game_state: GameState

func initialize(_game_state: GameState):
	game_state = _game_state
	game_state.player_tile_name_set.connect(_on_player_tile_name_set)

func _ready():
	change_tile_state.connect(_on_state_change)
	change_can_player_reach.connect(_on_can_player_reach_change)
	emit_signal("change_tile_state", tile_state)
	$Fire.play("flames")

func tile_state_to_string(_tile_state: TileState):
	match _tile_state:
		0: return "None"
		1: return "Fire"

func _on_state_change(_tile_state: TileState):
	tile_state = _tile_state
	match tile_state:
		0: $Fire.hide()
		1: 
			$Fire.show()
		2: 
			$Fire.hide()
			modulate = Color.WEB_PURPLE

func _on_can_player_reach_change(_can_player_reach):
	can_player_reach = _can_player_reach
	if can_player_reach:
		$Reachable.show()
	else:
		$Reachable.hide()
		$Hover.hide()

# Called when the player just moved
func _on_player_tile_name_set(player_tile_name):
	# If player is on this tile
	if player_tile_name == self.name:
		
		# Update our state to know that we have the player
		has_player = true
		
		# Visually display the player sprite
		$Player.show()
		
		# Put this tile above all others
#		z_index = 3
	else:
		# Update our state to know that we no longer have the player
		has_player = false
		
		# Visually hide the player sprite
		$Player.hide()
		
		# Put this tile below the player level
#		z_index = 1

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
	ray_cast.force_raycast_update()
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

# Mouse events and state ---------------------------------------------------------------------------

var previous_left_clicked = false
var previous_right_clicked = false
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
		handle_mouse_event(event)

# There are four combinations here: left down, left up, right down, right up.
func handle_mouse_event(event: InputEventMouseButton):
	var previous_clicked = previous_left_clicked or previous_right_clicked
	var is_mouse_down = !previous_clicked and event.is_pressed()
	var is_mouse_up = previous_clicked and !event.is_pressed()
	
	var is_left_event = event.button_index == MOUSE_BUTTON_LEFT
	var is_left_event_on_this_tile = mouse_over and is_left_event
	var is_right_event = event.button_index == MOUSE_BUTTON_RIGHT
	var is_right_event_on_this_tile = mouse_over and is_right_event
	
	var is_left_clicking_on_current_tile = is_mouse_down and is_left_event_on_this_tile
	var is_right_clicking_on_current_tile = is_mouse_down and is_right_event_on_this_tile
	var is_left_releasing = is_mouse_up and is_left_event
	var is_right_releasing = is_mouse_up and is_right_event
	
	if (is_left_clicking_on_current_tile):
		handle_left_mouse_down()
	if (is_left_releasing):
		handle_left_mouse_up()
	if (is_right_clicking_on_current_tile):
		handle_right_mouse_down()
	if (is_right_releasing):
		handle_right_mouse_up()

func handle_left_mouse_down():
	var can_player_light_stuff_on_fire = (
		game_state.player_fire_charge_count > 0 and
		game_state.active_turn == game_state.Turn.Player
	)
	var can_tile_be_lit_on_fire = (
		can_player_light_stuff_on_fire and 
		is_player_within_all_neighbors() and 
		is_flammable()
	)

	if can_tile_be_lit_on_fire:
		# Light the tile on fire
		emit_signal("change_tile_state", TileState.Fire)
		game_state.player_fire_charge_count -= 1
	
	previous_left_clicked = true

func handle_right_mouse_down():
	var can_player_move = game_state.player_moves_remaining > 0
	var can_player_reach_this_tile = can_player_reach
	var is_player_turn = game_state.active_turn == game_state.Turn.Player
	var can_move_to_tile = can_player_move and can_player_reach_this_tile and is_player_turn
	
	if can_move_to_tile: move_player_to_tile()
	
	previous_right_clicked = true

func handle_left_mouse_up():
	previous_left_clicked = false

func handle_right_mouse_up():
	previous_right_clicked = false
	
func is_flammable() -> bool:
	return tile_state != TileState.Fire 

func is_player_within_all_neighbors():
	for tile in get_all_neighbors():
		if tile.has_player: return true
	return false

func is_player_within_cardinal_neighbors():
	for tile in get_cardinal_neighbors():
		if tile.has_player: return true
	return false

func move_player_to_tile():
	set_sprite_direction()
	game_state.player_tile_name = self.name
	# TODO: we probably want to highlight the "end turn" button or something here
	# if game_state.player_moves_remaining == 1:
		# EventBus.emit_signal("turn_ended")
	game_state.player_moves_remaining -= 1

func set_sprite_direction():
	var current_player_tile = get_parent().find_child(game_state.player_tile_name)
	var neighbors: Array[Tile] = get_cardinal_neighbors_include_nulls()
	var tile_index = neighbors.find(current_player_tile)
	print("tile we just moved from", neighbors[tile_index])
	print("tile index we just moved from ", tile_index)
	match tile_index:
		0:
			# coming from NE
			$Player.frame = 0
			$Player.flip_h = false
		1:
			# coming from NW
			$Player.frame = 0
			$Player.flip_h = true
		2:
			# coming from SE
			$Player.frame = 1
			$Player.flip_h = true
		3:
			# coming from SW
			$Player.frame = 1
			$Player.flip_h = false
