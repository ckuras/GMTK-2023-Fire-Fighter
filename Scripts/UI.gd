extends Control

@onready var scene_switcher = get_parent().get_parent()

@onready var moves_left_label = $MarginContainer/VBoxContainer/HBoxContainer/PlayerActions/HBoxContainer/MovesLeftLabel
@onready var fire_charges_label = $MarginContainer/VBoxContainer/HBoxContainer/PlayerActions/HBoxContainer2/FireChargesLabel
@onready var active_turn_label = $MarginContainer/VBoxContainer/HBoxContainer/ActiveTurn/ActiveTurnLabel
@onready var rounds_until_rain_label = $MarginContainer/VBoxContainer/HBoxContainer/TurnCount/HBoxContainer/RoundsUntilRainLabel

@onready var end_turn_button = $MarginContainer/VBoxContainer/MarginContainer2/Button

var round_lost = false

func _ready():
	EventBus.connect("turn_changed", _on_turn_changed)
	EventBus.connect("moves_changed", _on_moves_changed)
	EventBus.connect("fire_charges_changed", _on_fire_charges_changed)
	EventBus.connect("rounds_left_changed", _on_rounds_left_changed)
	
	EventBus.connect("player_lost_round", _on_round_lost)

func _on_turn_changed(turn: String):
	active_turn_label.text = turn
	if turn == "PLAYER":
		end_turn_button.show()
	else:
		end_turn_button.hide()

func _on_moves_changed(moves):
	moves_left_label.text = str(moves)

func _on_fire_charges_changed(charges):
	fire_charges_label.text = str(charges)

func _on_rounds_left_changed(turns_left):
	rounds_until_rain_label.text = str(turns_left)

func _on_round_lost():
	round_lost = true
	end_turn_button.text = "RESET"
	end_turn_button.show()

func _on_button_button_down():
	if !round_lost:
		EventBus.emit_signal("turn_ended")
	else:
		EventBus.emit_signal("restart_level", scene_switcher.current_level_name)
		end_turn_button.text = "END TURN"
		round_lost = false
