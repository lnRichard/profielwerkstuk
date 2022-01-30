extends Node

# Highest score the player has achieved

var highscore = 0
var passed_levels = 0

onready var player = preload("res://characters/player/Player.tscn").instance();

var player_lvl = 1 setget set_level, get_level
var xp = 0 setget set_xp, get_xp

func _ready():
	print(123)

# Get xp var
func get_xp():
	return xp
	
	
# Set xp var
func set_xp(value: int):
	xp = value
	# Levelup while xp is enough
	while xp > player_lvl * 10:
		set_level(player_lvl + 1)

# set level var
func set_level(value: int):
	# Create levelup label
	player.indicator("Level Up!", Color(0.64, 0.67, 2.3), true)

	# Update player stats
	player_lvl = value
	player.max_health+=100
	player.current_health = player.max_health
	
	
func get_level():
	return player_lvl


