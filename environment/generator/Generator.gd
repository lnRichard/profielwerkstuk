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

# Map state
enum map_states {EMPTY, TILE, ENTRANCE, EXIT, PROP, ENEMY}
var map_state := []

# Enemies
var grunt := preload("res://characters/enemies/grunt/Grunt.tscn") # Grunt enemy to spawn

# Props
var crate := preload("res://props/crate/Crate.tscn")

# Misc
var entrance_point: int # Location of the entrance
var exit_point: int # Location of the exit


# Generates the map on initialization
func _ready():
	# Initialize the generator
	var gen_parameters = {
		"current_level": Global.passed_levels
	}

	# Initialize the map
	randomize()
	noise.seed = randi()
	noise.octaves = 5.0
	noise.period = 5

	# Generate map
	while !valid_path():
		reset_map()
		yield(get_tree().create_timer(0.01), "timeout")
		place_tiles()

	# Generate the map entities
	place_props(gen_parameters)
	place_enemies(gen_parameters)

	# Finalize the generation
	get_parent().player.global_position = $Entrance.position
	map_state.clear()

# Reset the map state
func reset_map():
	randomize()
	noise.seed = randi()
	noise.octaves = rand_range(5.0, 9.0)
	noise.period = 5

	# Empty dungeon
	map_state = []
	map_state.resize(dungeon_size.x)
	for x in dungeon_size.x:
		map_state[x] = []
		map_state[x].resize(dungeon_size.y)
		for y in dungeon_size.y:
			map_state[x][y] = map_states.EMPTY
			autotile.set_cell(x, y, -1)

	# Unset entrances
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
				map_state[x][y] = map_states.TILE

			# Generate entrance
			if c < entrance_exit_cap && !entrance_set:
				$Entrance.position = Vector2(x * 16 + 8, y * 16 + 8)
				entrance_set = true
				entrance_point = (x * dungeon_size.x) + y
				map_state[x][y] = map_states.ENTRANCE

	# Generate exit
	for x in range(dungeon_size.x -1, -1, -1):
		for y in range(dungeon_size.y -1, -1, -1):
			var c = noise.get_noise_2d(x, y)
			if c < entrance_exit_cap && !exit_set:
				$Exit.position = Vector2(x * 16, y * 16)
				exit_set = true
				exit_point = (x * dungeon_size.x) + y
				map_state[x][y] = map_states.EXIT
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
	return true

# Spawns the props on the map
func place_props(gen_parameters: Dictionary):
	# var space state;
	var space_state = get_world_2d().direct_space_state # State of the map
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	# Get enemy counts
	var props = get_prop_counts(gen_parameters, rng)
	
	# Spawn crates
	while props["crates"] > 0:
		spawn_prop(crate, rng)
		props["crates"] -= 1

# Gets amount of props to spawn of each type
func get_prop_counts(gen_parameters: Dictionary, rng: RandomNumberGenerator) -> Dictionary:
	return {
		"crates": rng.randi_range(3 + 1 * gen_parameters["current_level"], 3 + 1 * gen_parameters["current_level"])
	}

# Spawns a specific prop instance
func spawn_prop(type: PackedScene, rng: RandomNumberGenerator) -> bool:
	# Get prop pos
	var x = rng.randi_range(0, dungeon_size.x - 1)
	var y = rng.randi_range(0, dungeon_size.y - 1)

	# Check if tile is valid
	if map_state[x][y] != map_states.TILE:
		return false

	# Calculate coord
	var coord = Vector2(x * 16 + 8, y * 16 + 8)

	# Spawn the prop
	var prop = type.instance()
	add_child(prop)
	prop.position = coord
	map_state[x][y] = map_states.PROP
	return true


# Spawns the enemies on the map
func place_enemies(gen_parameters: Dictionary):
	# var space state;
	var space_state = get_world_2d().direct_space_state # State of the map
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	# Get enemy counts
	var enemies = get_enemy_counts(gen_parameters, rng)

	# Spawn grunts
	while enemies["grunts"] > 0:
		spawn_enemy(grunt, rng)
		enemies["grunts"] -= 1

# Gets amount of enemies to spawn of each type
func get_enemy_counts(gen_parameters: Dictionary, rng: RandomNumberGenerator) -> Dictionary:
	return {
		"grunts": rng.randi_range(5 + 5 * gen_parameters["current_level"], 10 + 5 * gen_parameters["current_level"])
	}

# Spawns a specific enemy instance
func spawn_enemy(type: PackedScene, rng: RandomNumberGenerator) -> bool:
	# Get enemy pos
	var x = rng.randi_range(0, dungeon_size.x - 1)
	var y = rng.randi_range(0, dungeon_size.y - 1)

	# Check if tile is valid
	if map_state[x][y] != map_states.TILE:
		return false

	# Calculate coord
	var coord = Vector2(x * 16 + 8, y * 16 + 8)

	# Do not generate around entrance
	if $Entrance.position.x + (5 * 16) >= coord.x and $Entrance.position.x - (5 * 16) <= coord.x:
		if $Entrance.position.y + (5 * 16) >= coord.y and $Entrance.position.y - (5 * 16) <= coord.y:
			return false

	# Spawn the enemy
	var enemy = type.instance()
	add_child(enemy)
	enemy.position = coord
	map_state[x][y] = map_states.ENEMY
	return true
