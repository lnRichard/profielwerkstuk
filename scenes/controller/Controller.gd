extends Node


onready var player = preload("res://scenes/characters/player/Player.tscn").instance();
var basic_dungeon = "res://scenes/rooms/basic_dungeon/";

var files = []

# room variables
var count = 0;
var iteration = 0;
var batch_count = 5;
var room;
var current_batch = [];

var enemies = [];
var enemy_folder = "res://scenes/characters/enemies/";
func _ready():
	enemies = file_process(enemy_folder)
	count_files_and_get_names() # files and count now have the right value;
	current_batch = batch_rooms(batch_count);
	load_next_room()

func batch_rooms(n: int) -> Array:
	var rng = RandomNumberGenerator.new();
	rng.randomize()
	var n_batch = [];
	for x in n:
		var index = rng.randi_range(0, count-1)
		n_batch.push_back(load(basic_dungeon + files[index]))
	return n_batch

func load_next_room():
	remove_child(room)
	if current_batch.size() < count:
		room = current_batch[count].instance();
		add_child(room)
		count+=1;
	else:
		iteration+=1;
		count = 0;
		batch_rooms(batch_count)
	
func _exit():
	load_next_room()
	
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

func file_process(path: String) -> Array:
	var enemy_folders = [];
	var enemy_scenes = [];
	var dir = Directory.new();
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var folder_name = dir.get_next();
		while folder_name != "":
			if (folder_name !="." && folder_name !=".." && folder_name != "hostile_entity"):
				enemy_folders.push_back(folder_name)
			folder_name = dir.get_next();
		dir.list_dir_end()
	for folder in enemy_folders:
		dir = Directory.new();
		if dir.open(path +folder +"/") == OK:
			dir.list_dir_begin()
			var poss_scene = dir.get_next();
			while poss_scene != "":
				if (poss_scene.get_extension() == "tscn"):
					enemy_scenes.push_back(load(path+folder+ "/" + poss_scene));
				poss_scene = dir.get_next();
			dir.list_dir_end()
	return enemy_scenes
	
func spawn_enemies():
	pass
	# spawn enemies based on room max weight?
	# assign weight / script to each room or maybe a node that has a value?
	# 
