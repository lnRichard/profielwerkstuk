extends Node

# Create Player
onready var player = preload("res://characters/player/Player.tscn").instance();
onready var generator = preload("res://environment/generator/Generator.tscn");

func _ready():
	var room = generator.instance();
	add_child(room)
	player.position = room.get_node("Entrance").position;
	add_child(player)
