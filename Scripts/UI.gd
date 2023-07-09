extends Control

@onready var moves_left_label = $MarginContainer/HBoxContainer/PlayerActions/HBoxContainer/MovesLeftLabel
@onready var fire_charges_label = $MarginContainer/HBoxContainer/PlayerActions/HBoxContainer2/FireChargesLabel
@onready var active_turn_label = $MarginContainer/HBoxContainer/ActiveTurn/ActiveTurnLabel
@onready var rounds_until_rain_label = $MarginContainer/HBoxContainer/TurnCount/HBoxContainer/RoundsUntilRainLabel


func _ready():
	EventBus.connect("turn_changed", _on_turn_changed)
	EventBus.connect("moves_changed", _on_moves_changed)
	EventBus.connect("fire_charges_changed", _on_fire_charges_changed)
	EventBus.connect("rounds_left_changed", _on_rounds_left_changed)

func _on_turn_changed(turn: String):
	active_turn_label.text = turn

func _on_moves_changed(moves):
	moves_left_label.text = str(moves)

func _on_fire_charges_changed(charges):
	fire_charges_label.text = str(charges)

func _on_rounds_left_changed(turns_left):
	rounds_until_rain_label.text = str(turns_left)
