extends Node2D

var exit_set = false;
var entrance_set = false;

onready var noise = OpenSimplexNoise.new();
var dungeon_size = Vector2(100, 100);

var tile_cap = 0.2;
var entrance_exit_cap = -0.5;

onready var autotile = get_node("Navigation2D/Map");


onready var nav: Navigation2D = $Navigation2D;

func _ready():
#	randomize()
	noise.seed = randi();
	noise.octaves = 2.0;
	noise.period = 5;
	place_tiles()
	valid_path();
	
func place_tiles():
	for x in dungeon_size.x:
		for y in dungeon_size.y:
			var c = noise.get_noise_2d(x, y);
			if c < tile_cap:
				autotile.set_cell(x, y, 0);
			if c < entrance_exit_cap && !entrance_set:
				$Entrance.position = Vector2((x+1)*16, (y+1)*16);
				print(Vector2(x*16, y*16))
				entrance_set = true;
	for x in range(dungeon_size.x-1, -1, -1):
		for y in range(dungeon_size.y-1, -1, -1):
			
			var c = noise.get_noise_2d(x, y);
			if c < entrance_exit_cap && !exit_set:
				print(Vector2(x*16, y*16))
				$Exit.position = Vector2(x*16, y*16);
				exit_set = true;
				break;
		if exit_set:
			break
	autotile.update_bitmask_region(Vector2(0, 0), dungeon_size)

func valid_path():
	var path = nav.get_simple_path($Entrance.global_position, $Exit.global_position);
#	var path = nav.get_simple_path(Vector2(10, 10), Vector2(20, 20));
	print(path)
#	print($Entrance.global_position, $Exit.global_position)
#	$Line2D.points = path;
