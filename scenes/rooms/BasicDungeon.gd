extends Node2D


export (int) var difficulty;
var enemies = [];


var enemy_folder = "res://scenes/characters/enemies/";
# Called when the node enters the scene tree for the first time.
func _ready():
	enemies = get_parent().enemies;


func _physics_process(delta):
	pass

func set_weight_multiplier(weight_multiplier: float):
	for x in get_children():
		if (x is SpawnNode):
			x.set_weight_multiplier(weight_multiplier)
	
	
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

func weigh_enemies():
	pass

func spawn_enemies(tospawn: Array):
	for enemy in tospawn:
		add_child(enemy)
