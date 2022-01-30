extends Node2D

# place_tiles()
onready var noise := OpenSimplexNoise.new() # Noise function
var exit_set := false # Exit has been generated
var entrance_set := false # Entrance has been generated
var enemy_count := 0 # Amount of enemies generated

# Settings
var dungeon_size := Vector2(25, 25) # Size of the dungeon
var tile_cap := 0.2 # Treshold for tile spawn
var enemy_cap := -0.2 # Treshold for enemy spawn
var entrance_exit_cap := -0.5 # Treshold for entrance spawn


# Onready
onready var autotile := $Map # Tilemap of the dungeon
onready var astar := AStar2D.new() # AStar pathfinding instance

# Misc
var grunt := preload("res://characters/enemies/grunt/Grunt.tscn") # Grunt enemy to spawn
var entrance_point: int # Location of the entrance
var exit_point: int # Location of the exit


# Initialize the generator
func _ready():
	randomize()
	noise.seed = randi()
	noise.octaves = 5.0
	noise.period = 5
	place_tiles()

# Generate the dungeon
func place_tiles():
	enemy_count = 0
	for x in dungeon_size.x:
		for y in dungeon_size.y:
			# Generate tiles
			var c = noise.get_noise_2d(x, y) # -1.0 to 1.0
			if c < tile_cap:
				var thispoint = (x * dungeon_size.x) + y
				astar.add_point(thispoint, Vector2(x * 16 + 8, y * 16 + 8))
				autotile.set_cell(x, y, 0)


			# Generate entrance
			if c < entrance_exit_cap && !entrance_set:
				$Entrance.position = Vector2(x * 16 + 8, y * 16 + 8)
				entrance_set = true
				entrance_point = (x * dungeon_size.x) + y
	for x in range(dungeon_size.x -1, -1, -1):
		for y in range(dungeon_size.y -1, -1, -1):
			var c = noise.get_noise_2d(x, y)
			if c < entrance_exit_cap && !exit_set:
				$Exit.position = Vector2(x * 16, y * 16)
				exit_set = true
				exit_point = (x * dungeon_size.x) + y
				break

	# Spawn enemies
	for x in dungeon_size.x:
		for y in dungeon_size.y:
			if noise.get_noise_2d(x, y) < enemy_cap:
				var coords = Vector2(x * 16 + 8, y * 16 + 8)
				if enemy_count > 50:
					pass
				if $Entrance.position.x + (10 * 16) < coords.x || $Entrance.position.x - (10 * 16) > coords.x:
					if $Entrance.position.y + (10 * 16) < coords.y || $Entrance.position.x - (10 * 16) > coords.y:
						var i = grunt.instance()
						enemy_count += 1
						i.position = coords
						add_child(i)
	$Entrance.position.x+=16 if $Entrance.position.x == 0 else 0;
	$Entrance.position.x-=16 if $Entrance.position.x == dungeon_size.x else 0;
	$Exit.position.y+=16 if $Exit.position.y == 0 else 0;
	$Exit.position.y-=16 if $Exit.position.y == dungeon_size.y else 0;
	
	# Generate exit
	for x in range(dungeon_size.x -1, -1, -1):
		for y in range(dungeon_size.y -1, -1, -1):
			var c = noise.get_noise_2d(x, y)
			if c < entrance_exit_cap && !exit_set:
				$Exit.position = Vector2(x * 16, y * 16)
				exit_set = true
				exit_point = (x * dungeon_size.x) + y
				break

		# Break if exit has been set
		if exit_set:
			break

	# Validate entrance to exit path and enemy count
	autotile.update_bitmask_region(Vector2(0, 0), dungeon_size)
	if !valid_path() || enemy_count < 20:
		get_tree().change_scene("res://main/Main.tscn")

# Checks if the path is valid
func valid_path() -> bool:
	if !entrance_point || !exit_point || !astar.get_id_path(entrance_point, exit_point):
		return false

#	$Line2D.points = astar.gentrance_pointoint_path(entrance_point, exit_point)
	return true
