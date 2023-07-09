extends Control

@onready var label = $HBoxContainer/VBoxContainer2/Label

func _ready():
	EventBus.connect("turn_changed", _on_turn_changed)

func _on_turn_changed(turn: String):
	label.text = "Turn: " + turn
