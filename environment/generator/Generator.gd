extends Node2D

var exit_set = false;
var entrance_set = false;


onready var noise = OpenSimplexNoise.new();
var dungeon_size = Vector2(100, 100);

var tile_cap = 0.2;
var entrance_exit_cap = -0.5;

onready var autotile = $Map

onready var astar = AStar2D.new()


var et_p;
var ex_p;
var points = [];
func _ready():
	randomize()
	noise.seed = randi();
	noise.octaves = 5.0;
	noise.period = 5;
	place_tiles()
	valid_path();
	
func place_tiles():
	for x in dungeon_size.x:
		for y in dungeon_size.y:
			var c = noise.get_noise_2d(x, y);
			if c < tile_cap:
				var thispoint = (x*dungeon_size.x)+y;
				astar.add_point(thispoint, Vector2(x, y))
				autotile.set_cell(x, y, 0);
				if astar.has_point(((x-1)*dungeon_size.x)+y):
					astar.connect_points(thispoint, ((x-1)*dungeon_size.x)+y)
				if astar.has_point((x*dungeon_size.x)+y-1):
					astar.connect_points(thispoint, ((x)*dungeon_size.x)+y-1)
			if c < entrance_exit_cap && !entrance_set:
				$Entrance.position = Vector2((x+1)*16, (y+1)*16);
				print($Entrance.position)
				entrance_set = true;
				et_p = (x*dungeon_size.x)+y;
	for x in range(dungeon_size.x-1, -1, -1):
		for y in range(dungeon_size.y-1, -1, -1):
			var c = noise.get_noise_2d(x, y);
			if c < entrance_exit_cap && !exit_set:
				$Exit.position = Vector2(x*16, (y-1)*16);
				print($Exit.position);
				exit_set = true;
				ex_p = (x*dungeon_size.x)+y;
				break;
		if exit_set:
			break
	autotile.update_bitmask_region(Vector2(0, 0), dungeon_size)

func valid_path():
	print(astar.get_id_path(et_p, ex_p))
