extends Node2D

func _ready():
	print("initializing tiles...")
	var i = 0
	for tile in get_children():
		print("initializing tile ", i)
		tile.tile_id = i
		i += 1
		
	print ("sending tiles_initialized signal")
	EventBus.emit_signal("tiles_initialized")
