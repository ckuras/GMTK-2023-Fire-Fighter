class_name GameState extends Node

signal player_tile_id_set(_player_tile_id)

enum Turn {
	Player,
	Fire,
	Infected
}

var active_turn = Turn.Player

@onready var player_tile_id = 0 : set = _set_player_tile_id

func _ready():
	self.player_tile_id = 0

func _set_player_tile_id(_player_tile_id):
	player_tile_id = _player_tile_id
	emit_signal("player_tile_id_set", player_tile_id)
