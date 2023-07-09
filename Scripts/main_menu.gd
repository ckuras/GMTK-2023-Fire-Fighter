extends CanvasLayer

@onready var main = $Main

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/introduction.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
