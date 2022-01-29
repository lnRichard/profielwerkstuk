extends Node

# Create Player
onready var player = preload("res://characters/player/Player.tscn").instance();
onready var generator = preload("res://environment/generator/Generator.tscn");
onready var RNG = RandomNumberGenerator.new();
onready var boss_rooms = [
		
]	


var xp = 0 setget set_xp, get_xp
var player_lvl = 1 setget set_level, get_level


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
	Global.highscore+=100;

func move_to_next_room():
	remove_child(room)
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
	var camera = player.get_node("Camera").duplicate();
	camera.global_position = player.global_position
	add_child(camera);
	player.queue_free()
	
	yield(get_tree().create_timer(2.0), "timeout")
	var restart = preload("res://gui/restart_menu/RestartMenu.tscn");
	get_tree().change_scene_to(restart);
	
func _enemy_death(score):
	total_score+=score;

func get_xp():
	return xp

func set_xp(value: int):
	xp=value;
	while xp > player_lvl*10:
		set_level(player_lvl+1)
		
func set_level(value: int):
	var levelup = preload("res://projectiles/damage_indicator/DamageIndicator.tscn").instance()
	var label = levelup.get_node("Label");
	label.text = "Level Up!"
	label.add_color_override("font_color", Color((255-191)/100.0, (255-188)/100.0, (255-25)/100.0))
	levelup.global_position = player.global_position;
	add_child(levelup)
	levelup.show_value(false)
	player_lvl = value
	player.max_health+=100;
	player.current_health = player.max_health
	print(player.max_health - player.current_health)

func get_level():
	return player_lvl
