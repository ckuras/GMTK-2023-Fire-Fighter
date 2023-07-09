extends Control

@onready var scene_switcher = get_parent().get_parent()

@onready var moves_left_label = $MarginContainer/VBoxContainer/HBoxContainer/PlayerActions/HBoxContainer/MovesLeftLabel
@onready var fire_charges_label = $MarginContainer/VBoxContainer/HBoxContainer/PlayerActions/HBoxContainer2/FireChargesLabel
@onready var active_turn_label = $MarginContainer/VBoxContainer/HBoxContainer/ActiveTurn/ActiveTurnLabel
@onready var rounds_until_rain_label = $MarginContainer/VBoxContainer/HBoxContainer/TurnCount/HBoxContainer/RoundsUntilRainLabel

@onready var end_turn_button = $MarginContainer/VBoxContainer/MarginContainer2/Button

@onready var lose_label = $MarginContainer/VBoxContainer/MarginContainer/LoseLabel

var moves_left: int
var fire_charges_left: int

var flashing_button = false

var round_lost = false
var round_won = false


func _ready():
	EventBus.connect("turn_changed", _on_turn_changed)
	EventBus.connect("moves_changed", _on_moves_changed)
	EventBus.connect("fire_charges_changed", _on_fire_charges_changed)
	EventBus.connect("rounds_left_changed", _on_rounds_left_changed)
	
	EventBus.connect("player_lost_round", _on_round_lost)
	EventBus.connect("player_won_round", _on_round_won)
	

func _on_turn_changed(turn: String):
	active_turn_label.text = turn
	if turn == "PLAYER":
		end_turn_button.show()
	else:
		end_turn_button.hide()

func _on_moves_changed(moves):
	moves_left = moves
	moves_left_label.text = str(moves)
	out_of_moves()

func _on_fire_charges_changed(charges):
	fire_charges_left = charges
	fire_charges_label.text = str(charges)
	out_of_moves()

func _on_rounds_left_changed(turns_left):
	rounds_until_rain_label.text = str(turns_left)

func _on_round_lost():
	round_lost = true
	
	_show_round_result("FAILURE")
	
	end_turn_button.text = "RESET"
	end_turn_button.show()
	flash_button()

func _on_round_won():
	round_won = true
	_show_round_result("SUCCESS")
	
	end_turn_button.text = "NEXT LEVEL"
	end_turn_button.show()
	flash_button()

func _show_round_result(result):
	lose_label.modulate.a = 0.0
	lose_label.text = result
	
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(lose_label, "modulate:a", 1.0, 2)
	tween.tween_property(lose_label, "modulate:a", 0.9, 2)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(lose_label, "modulate:a", 0.0, 2)

func _on_button_button_down():
	if round_lost:
		EventBus.emit_signal("restart_level", scene_switcher.current_level_name)
		round_lost = false
		end_turn_button.text = "END TURN"
		lose_label.text = ""
	elif round_won:
		scene_switcher.current_level.emit_signal("level_changed", "level_" + str(scene_switcher.current_level.level_number + 1))
		round_won = false
		end_turn_button.text = "END TURN"
		lose_label.text = ""
	elif !round_lost and !round_won:
		EventBus.emit_signal("turn_ended")

func out_of_moves():
	if moves_left == 0 or fire_charges_left == 0 and !flashing_button:
		flash_button()

func flash_button():
	flashing_button = true
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(end_turn_button, "modulate:a", 0.4, .1)
	tween.tween_property(end_turn_button, "modulate:a", 1.0, .1)
	tween.tween_property(end_turn_button, "modulate:a", 0.4, .2)
	tween.tween_property(end_turn_button, "modulate:a", 1.0, .2)
	tween.tween_property(end_turn_button, "modulate:a", 0.4, .2)
	tween.tween_property(end_turn_button, "modulate:a", 1.0, .2)
