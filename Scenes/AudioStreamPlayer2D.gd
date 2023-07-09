extends AudioStreamPlayer2D

enum MusicState {
	ON,
	OFF
}

var music_state = MusicState.ON
const mute_db = -100
const on_db = -12

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("toggle_mute", _on_toggle_mute)

func _on_toggle_mute():
	print("caught toggle_mute")
	if (music_state == MusicState.ON):
		stream_paused = true
		music_state = MusicState.OFF
		pass
		
	elif (music_state == MusicState.OFF):
		stream_paused = false
		music_state = MusicState.ON
		pass
