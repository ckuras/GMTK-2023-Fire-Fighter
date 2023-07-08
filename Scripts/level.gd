extends Node2D

signal level_changed(level_name)

@export var level_number: int = 0

func _ready():
	await get_tree().create_timer(1.0).timeout
	emit_signal("level_changed", "level_" + str(level_number + 1))
