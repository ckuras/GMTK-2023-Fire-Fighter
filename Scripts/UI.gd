extends Control

@onready var scene_switcher = get_parent().get_parent()

@onready var moves_left_label = $MarginContainer/VBoxContainer/HBoxContainer/PlayerActions/HBoxContainer/MovesLeftLabel
@onready var fire_charges_label = $MarginContainer/VBoxContainer/HBoxContainer/PlayerActions/HBoxContainer2/FireChargesLabel
@onready var active_turn_label = $MarginContainer/VBoxContainer/HBoxContainer/ActiveTurn/ActiveTurnLabel
@onready var rounds_until_rain_label = $MarginContainer/VBoxContainer/HBoxContainer/TurnCount/HBoxContainer/RoundsUntilRainLabel

@onready var next_action_button = $MarginContainer/VBoxContainer/MarginContainer2/Button

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
	match turn:
		"PLAYER":
			active_turn_label.modulate = Color(1,1,1,1)
			next_action_button.show()
		"FIRE":
			active_turn_label.modulate = Color.RED
			next_action_button.hide()
		"INFECTED":
			active_turn_label.modulate = Color.WEB_PURPLE
			next_action_button.hide()
		
	
	if turn == "PLAYER":
		next_action_button.show()
	else:
		next_action_button.hide()

func _on_moves_changed(moves):
	moves_left = moves
	moves_left_label.text = str(moves)
	if moves == 0:
		flash_node_red(moves_left_label)
		out_of_moves()

func _on_fire_charges_changed(charges):
	fire_charges_left = charges
	fire_charges_label.text = str(charges)
	if charges == 0:
		flash_node_red(fire_charges_label)
		out_of_moves()

func _on_rounds_left_changed(turns_left):
	rounds_until_rain_label.text = str(turns_left)
	await flash_node_red(rounds_until_rain_label)

func _on_round_lost():
	round_lost = true
	
	_show_round_result("FAILURE")
	
	next_action_button.text = "RESET"
	next_action_button.show()
	flash_button()

func _on_round_won():
	round_won = true
	_show_round_result("SUCCESS")
	
	next_action_button.text = "NEXT LEVEL"
	next_action_button.show()
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
		next_action_button.text = "END TURN"
		lose_label.text = ""
	elif round_won:
		scene_switcher.current_level.emit_signal("level_changed", "level_" + str(scene_switcher.current_level.level_number + 1))
		round_won = false
		next_action_button.text = "END TURN"
		lose_label.text = ""
	elif !round_lost and !round_won:
		EventBus.emit_signal("turn_ended")

func out_of_moves():
	if moves_left == 0 and fire_charges_left == 0 and !flashing_button:
		flash_button()

func flash_button():
	flashing_button = true
	await flash_property(next_action_button, "modulate:a")
	flashing_button = false

func flash_property(node: Node, property: String):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.set_loops(3)
	tween.tween_property(node, property, 0.4, .2)
	tween.tween_property(node, property, 1.0, .2)
	return tween.finished

func flash_node_red(node):
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.set_loops(3)
	tween.tween_property(node, "modulate", Color.RED, .25)
	tween.tween_property(node, "modulate", Color(1,1,1,1), .25)
	return tween.finished


