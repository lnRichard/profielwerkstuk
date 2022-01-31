extends Node

# Onready
onready var player := preload("res://characters/player/Player.tscn").instance();
onready var generator := preload("res://environment/generator/Generator.tscn")
onready var RNG := RandomNumberGenerator.new()
onready var boss_rooms := []

# Misc
var room # Current room
var total_score = 0 # Total score this game


# Initialize the game
func _ready():
	_start_game()
	Global.player = player

# Start the game
func _start_game():
	# Reset level counter
	Global.passed_levels = 0

	# Generate a new room
	room = generator.instance()
	add_child(room)

	# Send player to entrance
	player.position = room.get_node("Entrance").position
	add_child(player)

# Player exists the current level
func _exit():
#	yield(get_tree().create_timer(1.0), "timeout")
	move_to_next_room()
	Global.passed_levels+=1
	Global.highscore+=100

# Player moves to the next room
func move_to_next_room():
	remove_child(room)
	
	# Check new room type
#	if Global.passed_levels % 3 == 0:
		# Default room
	room = generator.instance()
#	else:
#		# Boss room
#		RNG.randomize()
#		var result = RNG.randi_range(0, boss_rooms.size() - 1)
#		room = boss_rooms[result].instance()

	# Add room and move player
	add_child(room)
	move_child(room, 0)
	player.position = room.get_node("Entrance").position

# Player loses the game
func _game_over():
	var camera = player.get_node("Camera").duplicate()
	camera.global_position = player.global_position
	add_child(camera)
	player.queue_free()

	yield(get_tree().create_timer(2.0), "timeout")
	var restart = preload("res://gui/restart_menu/RestartMenu.tscn")
	get_tree().change_scene_to(restart)




