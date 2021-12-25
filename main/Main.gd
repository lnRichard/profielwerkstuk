extends Node

# Create Player
onready var player = preload("res://characters/player/Player.tscn").instance();
onready var generator = preload("res://environment/generator/Generator.tscn");

var room;

func _ready():
	room = generator.instance();
	add_child(room)
	player.position = room.get_node("Entrance").position;
	add_child(player)

func _exit():
	remove_child(room);
	room = generator.instance();
	add_child(room);
	move_child(room, 0);
	player.position = room.get_node("Entrance").position;
