class_name GameState extends Node

signal player_tile_name_set(_player_tile_name)

enum Turn {
	Player,
	Fire,
	Infected
}

var active_turn = Turn.Player

@onready var level = get_parent()
#################### level ###### Board ###### Tiles ###### 
@onready var tiles = get_parent().get_child(0).get_child(0).get_children()

@export var player_tile_name = "Tile" : set = _set_player_tile_name
@export var player_moves_max_for_level: int
@export var player_moves_remaining: int : set = _set_player_moves_remaining
@export var player_fire_charge_max_for_level: int
@export var player_fire_charge_count: int : set = _set_player_fire_charge_count
@export var rounds_remaining_for_current_level: int : set = _set_rounds_remaining_for_current_level

func _ready():
	var array_with_just_player_tile = tiles.filter(func(t: Tile): return t.has_player)
	# If we found the tile wit the player
	if (array_with_just_player_tile.size() >= 1):
		print("Found player to start on tile ", array_with_just_player_tile[0].name, " for this level")
		self.player_tile_name = array_with_just_player_tile[0].name
	else:
		print("Could not find any player tiles, setting to \"Tile\" and hoping for the best")
		self.player_tile_name = "Tile"
	
	self.player_moves_remaining = player_moves_max_for_level
	self.player_fire_charge_count = player_fire_charge_max_for_level
### Boilerplate

func _set_player_tile_name(_player_tile_name):
	player_tile_name = _player_tile_name
	emit_signal("player_tile_name_set", player_tile_name)

func _set_player_moves_remaining(_player_moves_remaining):
	player_moves_remaining = _player_moves_remaining

func _set_player_fire_charge_count(_player_fire_charge_count):
	player_fire_charge_count = _player_fire_charge_count

func _set_rounds_remaining_for_current_level(_rounds_remaining_for_current_level):
	rounds_remaining_for_current_level = _rounds_remaining_for_current_level
