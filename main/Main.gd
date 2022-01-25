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
	_start_game()
	

func _start_game():
	room = generator.instance()
	add_child(room)
	player.position = room.get_node("Entrance").position;
	add_child(player)	

func _exit():
	
	yield(get_tree().create_timer(1.0), "timeout")
	move_to_next_room()
	passed_levels+=1;
	total_score+=100;

func move_to_next_room():
	remove_child(room);
	if passed_levels % 3 == 0:
		room = generator.instance();
	else:
		RNG.randomize();
		var result = RNG.randi_range(0, boss_rooms.size() - 1);
		room = boss_rooms[result].instance();
	add_child(room);
	move_child(room, 0);
	player.position = room.get_node("Entrance").position;
	
		

func _game_over():
	var restart = preload("res://gui/restart_menu/RestartMenu.tscn");
	Global.highscore = total_score
	get_tree().change_scene_to(restart);
	
func _enemy_death(score):
	total_score+=score;

