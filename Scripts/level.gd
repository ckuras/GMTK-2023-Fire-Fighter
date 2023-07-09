extends Node2D

signal level_changed(level_name)

@onready var game_state: GameState = $GameState

@export var level_number: int

func _ready():
	print("waiting for player to win round...")
	await EventBus.player_won_round
#	emit_signal("level_changed", "level_" + str(level_number + 1))
