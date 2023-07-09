extends Control


func _ready():
	EventBus.connect("turn_changed", _on_turn_changed)

func _on_turn_changed(turn: String):
#	label.text = "Turn: " + turn
	pass
