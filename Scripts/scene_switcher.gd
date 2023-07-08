extends Node

@onready var current_level = $Level1

func _ready():
	current_level.connect("level_changed", _handle_level_change)

func _handle_level_change(next_level_name: String):
	var next_level = load("res://Scenes/Levels/" + next_level_name + ".tscn").instantiate()
	get_tree().root.add_child(next_level)
	next_level.connect("level_changed", _handle_level_change)
	current_level.queue_free()
	current_level = next_level
