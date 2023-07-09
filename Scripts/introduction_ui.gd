extends CanvasLayer

var continued_story = false

@onready var story_label = $Main/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/StoryLabel
@onready var instructions_label = $Main/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/InstructionsLabel

func _on_continue_button_pressed():
	if continued_story:
		get_tree().change_scene_to_file("res://Scenes/scene_switcher.tscn")
	else:
		story_label.hide()
		instructions_label.show()
		continued_story = true
