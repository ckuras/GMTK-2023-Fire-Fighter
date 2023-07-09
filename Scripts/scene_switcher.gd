extends Node

@onready var current_level = $Level
@onready var current_level_name = "level_1"

func _ready():
	current_level.connect("level_changed", _handle_level_change)
	EventBus.connect("restart_level", _handle_level_change)

func _handle_level_change(next_level_name: String):
	current_level.queue_free()
	current_level_name = next_level_name
	await get_tree().create_timer(0.2).timeout
	
	var next_level = load("res://Scenes/Levels/" + next_level_name + ".tscn").instantiate()
	self.add_child(next_level)
	next_level.connect("level_changed", _handle_level_change)
	current_level = next_level

func _handle_level_restart():
	print("Restarting level")
	var next_level = load("res://Scenes/Levels/" + current_level_name + ".tscn").instantiate()
	self.add_child(next_level)

func _unhandled_input(event):
	if event is InputEventKey:
		var was_r_pressed = event.get_keycode_with_modifiers() == KEY_R and event.is_pressed()
		var was_space_pressed = event.get_keycode_with_modifiers() == KEY_SPACE and event.is_pressed()
		var was_one_pressed = event.get_keycode_with_modifiers() == KEY_1 and event.is_pressed()
		var was_two_pressed = event.get_keycode_with_modifiers() == KEY_2 and event.is_pressed()
		var was_three_pressed = event.get_keycode_with_modifiers() == KEY_3 and event.is_pressed()
		var was_four_pressed = event.get_keycode_with_modifiers() == KEY_4 and event.is_pressed()
		var was_five_pressed = event.get_keycode_with_modifiers() == KEY_5 and event.is_pressed()
		var was_six_pressed = event.get_keycode_with_modifiers() == KEY_6 and event.is_pressed()
		var was_seven_pressed = event.get_keycode_with_modifiers() == KEY_7 and event.is_pressed()
		var was_eight_pressed = event.get_keycode_with_modifiers() == KEY_8 and event.is_pressed()
		var was_nine_pressed = event.get_keycode_with_modifiers() == KEY_9 and event.is_pressed()
		
		if was_r_pressed:
			EventBus.emit_signal("restart_level", current_level_name)
			pass
		if was_space_pressed:
			print("emitting turn_ended")
			EventBus.emit_signal("turn_ended")
			pass
		if was_one_pressed:
			current_level.emit_signal("level_changed", "level_1")
			pass
		if was_two_pressed:
			current_level.emit_signal("level_changed", "level_2")
			pass
		if was_three_pressed:
			current_level.emit_signal("level_changed", "level_3")
			pass
		if was_four_pressed:
			current_level.emit_signal("level_changed", "level_4")
			pass
		if was_five_pressed:
			current_level.emit_signal("level_changed", "level_5")
			pass
		if was_six_pressed:
			current_level.emit_signal("level_changed", "level_6")
			pass
		if was_seven_pressed:
			current_level.emit_signal("level_changed", "level_7")
			pass
		if was_eight_pressed:
			current_level.emit_signal("level_changed", "level_8")
			pass
		if was_nine_pressed:
			current_level.emit_signal("level_changed", "level_9")
			pass
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
			pass

