extends Node

@onready var current_level = $Level1

func _ready():
	print("made a new scene switcher")
	current_level.connect("level_changed", _handle_level_change)
	EventBus.connect("restart_level", _handle_level_restart)

func _handle_level_change(next_level_name: String):
	current_level.queue_free()
	await get_tree().create_timer(0.1).timeout
	
	var next_level = load("res://Scenes/Levels/" + next_level_name + ".tscn").instantiate()
	self.add_child(next_level)
	next_level.connect("level_changed", _handle_level_change)
#	current_level.queue_free()
	current_level = next_level

func _handle_level_restart():
	print("restarting level")
	get_tree().reload_current_scene()

func _unhandled_input(event):
	if event is InputEventKey:
		var was_shift_pressed = event.get_keycode_with_modifiers() == KEY_SHIFT and event.is_pressed()
		var was_space_pressed = event.get_keycode_with_modifiers() == KEY_SPACE and event.is_pressed()
		
		if was_shift_pressed:
			EventBus.emit_signal("restart_level")
			pass
		if was_space_pressed:
			EventBus.emit_signal("turn_ended")
			pass
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

