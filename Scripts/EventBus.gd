extends Node

signal game_state_initialized
signal level_initialized

signal turn_ended
signal player_won_round
signal player_lost_round
signal restart_level

signal turn_changed(turn)
signal moves_changed(moves)
signal fire_charges_changed(charges)
signal rounds_left_changed(turns_left)
