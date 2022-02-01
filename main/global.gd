extends Node

# Options
var smoothing = true
var lighting = true

# Highest score the player has achieved

# Game stats
var highscore = 0 setget set_score, get_score # Highest score achieved
var passed_levels = 0 setget set_passed_levels, get_passed_levels # Amount of levels passed

# Player reference
var player; # Reference to the player

# Player stats
var player_lvl = 1 setget set_level, get_level # Player's current level
var xp = 0 setget set_xp, get_xp # Player's xp


# Map & Camera size
var mapcamera_size := Vector2(25, 25)

# Elite enemy kills
var elite_kills: int = 0
var skill_points: int = 0

func get_score():
	return highscore
	
func set_score(value: int):
	if is_instance_valid(player):
		print(value)
		player.get_node("UILayer/UI/ManaBar/Info/Score").text = String(value) + " Score"
	highscore = value

func get_passed_levels():
	return passed_levels
	
func set_passed_levels(value: int):
	if is_instance_valid(player):
		player.get_node("UILayer/UI//ManaBar/Info/Stage").text = "Stage " + String(value)
	passed_levels = value

# Get xp var
func get_xp():
	return xp

# Set xp var
func set_xp(value: int):
	xp = value
	# Levelup while xp is enough
	while xp > player_lvl * 25:
		set_level(player_lvl + 1)

# set level var
func set_level(value: int):
	if not is_instance_valid(player):
		return
	player.get_node("UILayer/UI//ManaBar/XP").text = "Level " + String(value)
	# Create levelup label
	player.indicator("Level Up!", Color(0.64, 0.67, 2.3), true)

	# Update player stats
	player_lvl = value
	player.max_health += 50
	player.current_health += 50

# Get the player's current level
func get_level():
	return player_lvl
