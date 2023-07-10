extends GutTest

# is_flammable

func test_that_a_tile_already_on_fire_is_not_considered_flammable():
	var result = Tile.is_flammable(Tile.TileState.Fire)
	
	assert_false(result, "A tile that is already on fire should not be considered flammable.")
	
func test_that_a_tile_without_a_state_is_considered_flammable():
	var result = Tile.is_flammable(Tile.TileState.None)
	
	assert_true(result, "A tile with the 'None' state should be considered flammable.")

func test_that_an_infected_tile_is_considered_flammable():
	var result = Tile.is_flammable(Tile.TileState.Infected)
	
	assert_true(result, "A tile that is infected should be considered flammable.")

# is_player_in_this_list_of_tiles

func test_that_an_empty_list_of_tiles_does_not_contain_a_player():
	var result = Tile.is_player_in_this_list_of_tiles([])
	
	assert_false(result, "An empty list of tiles should be considered to be containing a player.")

func test_that_a_list_of_tiles_that_does_not_contain_a_player_is_not_considered_to_contain_a_player():
	var tile_without_a_player = autofree(Tile.new())
	tile_without_a_player.has_player = false

	var result = Tile.is_player_in_this_list_of_tiles([
		tile_without_a_player,
		tile_without_a_player,
		tile_without_a_player
	])
	
	assert_false(result, "A list of tiles without a player should not be considered to be containing a player.")

func test_that_a_list_of_tiles_that_contains_one_player_is_considered_to_contain_a_player():
	var tile_without_a_player = autofree(Tile.new())
	var tile_with_a_player = autofree(Tile.new())

	tile_without_a_player.has_player = false
	tile_with_a_player.has_player = true

	var result = Tile.is_player_in_this_list_of_tiles([
		tile_without_a_player,
		tile_with_a_player,
		tile_without_a_player
	])

	assert_true(result, "A list of tiles with one player should be considered to be containing a player.")
