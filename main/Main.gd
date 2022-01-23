extends Node

# Create Player
onready var player = preload("res://characters/player/Player.tscn").instance();
onready var generator = preload("res://environment/generator/Generator.tscn");
onready var RNG = RandomNumberGenerator.new();
onready var boss_rooms = [
		
]	

var room;

var passed_levels = 0;

var total_score = 0;

var startscreen;

var quit_screen;

func _ready():
	startscreen = preload("res://gui/start_screen/StartScreen.tscn").instance();
	add_child(startscreen)
	

func _start_game():
	remove_child(startscreen)
	room = generator.instance()
	add_child(room)
	player.position = room.get_node("Entrance").position;
	add_child(player)	

func _exit():
	total_score+=100;
	passed_levels+=1;
	remove_child(room);
	if passed_levels % 3 != 0:
		room = generator.instance();
	else:
		RNG.randomize();
		var result = RNG.randi_range(0, boss_rooms.size() - 1);
		room = boss_rooms[result].instance();
	add_child(room);
	move_child(room, 0);
	player.position = room.get_node("Entrance").position;

func _input(event):
	if Input.is_action_just_pressed("key_a"):
		quit_screen = preload("res://gui/menu_screen/MenuScreen.tscn").instance();
		add_child(quit_screen)

func _continue_game():
	remove_child(quit_screen)		

func _game_over():
	pass
	
func _enemy_death(score):
	total_score+=score;