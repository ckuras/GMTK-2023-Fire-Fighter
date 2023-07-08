class_name GameState extends Node

signal player_tile_id_set(_player_tile_id)

enum Turn {
	Player,
	Fire,
	Infected
}

var active_turn = Turn.Player

@onready var player_tile_id = 4 : set = _set_player_tile_id
@onready var player_moves_remaining = 2 : set = _set_player_moves_remaining

func _ready():
	self.player_tile_id = 4
	self.player_moves_remaining = 2

func _set_player_tile_id(_player_tile_id):
	player_tile_id = _player_tile_id
	emit_signal("player_tile_id_set", player_tile_id)
	
func _set_player_moves_remaining(_player_moves_remaining):
	player_moves_remaining = _player_moves_remaining
	emit_signal("player_moves")
