extends Node

# Create Player
onready var player = preload("res://characters/player/Player.tscn").instance();
onready var generator = preload("res://environment/generator/Generator.tscn");
onready var RNG = RandomNumberGenerator.new();
onready var boss_rooms = [
	preload("res://environment/rooms/template/Template.tscn"),
	
	
]	

var room;

var passed_levels = 0;



func _ready():
	room = generator.instance();
	add_child(room)
	player.position = room.get_node("Entrance").position;
	add_child(player)

func _exit():
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
