extends CanvasLayer

var continued_story = false

@onready var story_label = $Main/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/StoryLabel
@onready var credits = $Main/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/Credits
@onready var continue_button = $Main/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ContinueButton

func _on_continue_button_pressed():
	if continued_story:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	else:
		story_label.hide()
		credits.show()
		continued_story = true
		continue_button.text = "Main Menu"

func _unhandled_input(event):
	if event.pressed and event.keycode == KEY_ESCAPE:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
