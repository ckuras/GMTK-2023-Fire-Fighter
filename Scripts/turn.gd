class_name Turn extends Node

signal completed

@onready var board: Board = get_parent().board
@onready var game_state: GameState = get_parent().game_state
