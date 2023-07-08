extends Node2D

func _ready():
	var i = 0
	for tile in get_children():
		tile.tile_id = i
		i += 1
