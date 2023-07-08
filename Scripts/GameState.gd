class_name GameState extends Node

signal game_state_initialized
signal player_tile_name_set(_player_tile_name)

enum Turn {
	Player,
	Fire,
	Infected
}

var active_turn = Turn.Player

@onready var player_tile_name = "Tile" : set = _set_player_tile_name
@onready var player_moves_remaining = 2 : set = _set_player_moves_remaining
@onready var player_fire_charge_count: = 1 : set = _set_player_fire_charge_count

@onready var rounds_remaining_for_current_level = 3 : set = _set_rounds_remaining_for_current_level

func _ready():
#	self.player_tile_name = "Tile"
#	self.player_moves_remaining = 2
#	self.player_fire_charge_count = 1
	emit_signal("game_state_initialized")

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
