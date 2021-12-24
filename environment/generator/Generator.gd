extends Node2D


onready var noise = OpenSimplexNoise.new();
var dungeon_size = Vector2(50, 50);
var tile_cap = 0.2;

func _ready():
	randomize()
	noise.seed = randi();
	noise.octaves = 2.0;
	noise.period = 5;
	place_tiles()
	
func place_tiles():
	for x in dungeon_size.x:
		for y in dungeon_size.y:
			var c = noise.get_noise_2d(x, y);
			if c < tile_cap:
				$PlainDungeonAutoTile.set_cell(x, y, 0);
	$PlainDungeonAutoTile.update_bitmask_region(Vector2(0, 0), dungeon_size)
