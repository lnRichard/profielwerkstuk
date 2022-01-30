extends Node2D

# place_tiles()
onready var noise := OpenSimplexNoise.new() # Noise function
var exit_set := false # Exit has been generated
var entrance_set := false # Entrance has been generated
var enemy_count := 0 # Amount of enemies generated
var enemy_min := 20 # Min amount of enemies


# Settings
var dungeon_size := Vector2(25, 25) # Size of the dungeon
var tile_cap := 0.2 # Treshold for tile spawn
var enemy_cap := 0.2 # Treshold for enemy spawn
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
	while !valid_path():
		reset_map()
		yield(get_tree().create_timer(0.01), "timeout")
		place_tiles()
	get_parent().player.global_position = $Entrance.position
	place_enemies()

func reset_map():
	randomize()
	noise.seed = randi()
	noise.octaves = rand_range(5.0, 9.0)
	noise.period = 5
	for x in dungeon_size.x:
		for y in dungeon_size.y:
			autotile.set_cell(x, y, -1)
	entrance_set = false
	exit_set = false
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


#	$Entrance.position.x+=16 if $Entrance.position.x == 0 else 0;
#	$Entrance.position.x-=16 if $Entrance.position.x == dungeon_size.x else 0;
#	$Exit.position.y+=16 if $Exit.position.y == 0 else 0;
#	$Exit.position.y-=16 if $Exit.position.y == dungeon_size.y else 0;
	
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

# Checks if the path is valid
func valid_path() -> bool:
	if !entrance_point || !exit_point || !astar.get_id_path(entrance_point, exit_point):
		return false

#	$Line2D.points = astar.gentrance_pointoint_path(entrance_point, exit_point)
	return true



func place_enemies():
	# var space state;
	var space_state = get_world_2d().direct_space_state # State of the map
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var enemies_num = rng.randi_range(10, 20)
	
	rng.randomize()
	for i in range(enemies_num):
		var x = rng.randi_range(0, dungeon_size.x)
		var y = rng.randi_range(0, dungeon_size.y)
	
		var coord = Vector2(x*16 + 8, y*16 + 8)
		
		var gamerray = space_state.intersect_point(coord, 32, [])
		print(gamerray)
		if gamerray.empty():
			var e = grunt.instance()
			add_child(e)
			e.position = coord
		
	
	
		# Spawn enemies
	
#				if $Entrance.position.x + (10 * 16) < coords.x || $Entrance.position.x - (10 * 16) > coords.x:
#					if $Entrance.position.y + (10 * 16) < coords.y || $Entrance.position.x - (10 * 16) > coords.y:

