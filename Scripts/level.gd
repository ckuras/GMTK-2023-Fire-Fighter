extends Node2D

signal level_changed(level_name)

@onready var game_state: GameState = get_child(3)
@onready var tiles: Array[Node] = get_child(1).get_child(0).get_children()

@export var level_number: int = 0
@export var player_tile_id: int
@export var player_moves_remaining: int
@export var player_fire_charge_count: int

func _ready():
	print("Waiting for tiles to be initialized...")
	await EventBus.tiles_initialized
	print("initializing game state with level data")
	for tile in tiles:
		print (tile.tile_id, ": has player = ", tile.has_player)
	var array_with_just_player_tile = tiles.filter(func(t: Tile): return t.has_player)
	# If we found the tile wit the player
	if (array_with_just_player_tile.size() == 1):
		print("Found player to start on tile ", array_with_just_player_tile[0].tile_id, " for this level")
		game_state.player_tile_id = array_with_just_player_tile[0].tile_id
	else:
		game_state.player_title_id = 0

	game_state.player_moves_remaining = player_moves_remaining
	game_state.player_fire_charge_count = player_fire_charge_count

	print("waiting for player to win round...")
	await EventBus.player_won_round
	emit_signal("level_changed", "level_" + str(level_number + 1))
