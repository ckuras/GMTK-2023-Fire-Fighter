extends CanvasLayer

@onready var main = $Main
@onready var settings = $Settings


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/scene_switcher.tscn")


func _on_settings_button_pressed():
	main.visible = false
	settings.visible = true

func _on_quit_button_pressed():
	get_tree().quit()

func _on_button_settings_back_pressed():
	main.visible = true
	settings.visible = false

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
