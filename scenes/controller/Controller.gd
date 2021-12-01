extends Node


onready var player = preload("res://scenes/characters/player/Player.tscn").instance();
var basic_dungeon = "res://scenes/rooms/basic_dungeon/";
var room;
var files = []
var count = 0;

func _ready():

	count_files_and_get_names() # files and count now have the right value;
	
	pick_room();

func pick_room():
	var rng = RandomNumberGenerator.new();
	rng.randomize();

	var result = rng.randi_range(0, count-1);
	load_room(result);
func load_room(index: int):
	room = load(basic_dungeon + files[index]).instance();
	add_child(room);
	add_child(player);
	
func _exit():
	remove_child(room);
	room.queue_free();
	var rng = RandomNumberGenerator.new();
	rng.randomize();
	var index = rng.randi_range(0, count-1);
	room = load(basic_dungeon + files[index]).instance();
	add_child(room);
	add_child(player);
	
func count_files_and_get_names():
	var dir = Directory.new();
	if dir.open(basic_dungeon) == OK:
		dir.list_dir_begin();
		var file_name = dir.get_next();
		while file_name != "":
			if (file_name.get_extension() == "tscn"):
				files.push_back(file_name)
				count+=1;
			file_name = dir.get_next();
		dir.list_dir_end()


func test():
	pass
	# get entrance and exit for the room
	# load them as instance variables
	# then spawn player at entrance
	# check when exit is triggered and if all enemies ar edead
	
func spawn_enemies():
	pass
	# spawn enemies based on room max weight?
	# assign weight / script to each room or maybe a node that has a value?
	# 
