extends Node2D

# place_tiles()
onready var noise := OpenSimplexNoise.new() # Noise function
var exit_set := false # Exit has been generated
var entrance_set := false # Entrance has been generated

# Settings
var dungeon_size := Global.mapcamera_size # Size of the dungeon
var tile_cap := 0.2 # Treshold for tile spawn

# Onready
onready var autotile := $Map # Tilemap of the dungeon
onready var astar := AStar2D.new() # AStar pathfinding instance

# Map state
enum map_states {EMPTY, TILE, ENTRANCE, EXIT, PROP, ENEMY}
var map_state := []

# Enemies
var enemies = { # Links enemy names to instances
	"grunt": preload("res://characters/enemies/grunt/Grunt.tscn"), # Grunt enemy to spawn
	"masked_grunt": preload("res://characters/enemies/masked_grunt/MaskedGrunt.tscn"), # Exploding grunt enemy to spawn
	"paint_grunt": preload("res://characters/enemies/paint_grunt/PaintGrunt.tscn"), # shaman enemy to spawn
	"zombie": preload("res://characters/enemies/zombie/Zombie.tscn"), # zombie to spawn
	"big_grunt": preload("res://characters/enemies/big_grunt/BigGrunt.tscn"), # Big grunt to spawn
	"elite": preload("res://characters/enemies/elite/Elite.tscn")
}
var enemies_sizes = { # Checks if an enemy is big
	"grunt": false,
	"masked_grunt": false,
	"paint_grunt": false,
	"zombie": false,
	"big_grunt": true,
	"elite": false
}

# Props
var props = {
	"crate": preload("res://props/crate/Crate.tscn"), # Crate to spawn
}

# Misc
var entrance_point: int # Location of the entrance
var exit_point: int # Location of the exit


# Generates the map on initialization
func _ready():
	# Initialize the generator
	var gen_parameters = {
		"current_level": Global.passed_levels
	}

	# Randomize the noise
	randomize_noise()

	# Generate map
	reset_map()
	place_tiles()

	# Generate the map obstructables
	place_props(gen_parameters)
	while !place_portals(gen_parameters): yield(get_tree().create_timer(1), "timeout")
	$Entrance.open()

	# Generate the enemies
	place_enemies(gen_parameters)

	# Finalize the generation
	get_parent().player.global_position = $Entrance.position
	get_parent().player.space_state = get_world_2d().direct_space_state
	map_state.clear()

# Reset the map state
func reset_map():
	randomize_noise()

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

# Randomises the noise function
func randomize_noise():
	randomize()
	noise.seed = randi()
	noise.octaves = rand_range(5.0, 9.0)
	noise.period = 5

# Generate the dungeon
func place_tiles():
	for x in dungeon_size.x:
		for y in dungeon_size.y:
			# Generate tiles
			var c = noise.get_noise_2d(x, y) # -1.0 to 1.0
			if c < tile_cap:
				var thispoint = (x * dungeon_size.x) + y
				astar.add_point(thispoint, Vector2(x * 16 + 8, y * 16 + 8))
				autotile.set_cell(x, y, 0)
				map_state[x][y] = map_states.TILE

				# Update astar connections
				if astar.has_point(((x - 1) * dungeon_size.x) + y):				
					astar.connect_points(thispoint, ((x - 1) * dungeon_size.x) + y)
				if astar.has_point((x * dungeon_size.x) + y - 1):
					astar.connect_points(thispoint, (x * dungeon_size.x) + y - 1)

	# Update the tile bitmask
	autotile.update_bitmask_region(Vector2(0, 0), dungeon_size)

# Places the entrance and exit
func place_portals(gen_parameters):
	# Initialize variables
	var entrances = 1
	var exits = 1

	# Create rng
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	# Place portals and validate
	while !place_entrance(rng): true
	while !place_exit(rng): true
	return valid_path()

# Places the entrance
func place_entrance(rng: RandomNumberGenerator) -> bool:
	# Get entrance pos
	var x = rng.randi_range(1, dungeon_size.x - 2) # Offset so the portals don't spawn on the edges
	var y = rng.randi_range(1, dungeon_size.y - 2) # Offset so the portals don't spawn on the edges

	# Check if tile is valid
	if map_state[x][y] != map_states.TILE or map_state[x][y + 1] != map_states.TILE or map_state[x][y - 1] != map_states.TILE:
		return false
	elif map_state[x + 1][y] != map_states.TILE or map_state[x - 2][y] != map_states.TILE:
		return false

	# Calculate coord
	var coord = Vector2(x * 16 + 8, y * 16 + 8)

	# Spawn the entrance
	$Entrance.position = coord
	entrance_set = true
	entrance_point = (x * dungeon_size.x) + y
	map_state[x][y] = map_states.ENTRANCE
	return true

# Places the exit
func place_exit(rng: RandomNumberGenerator) -> bool:
	# Get entrance pos
	var x = rng.randi_range(1, dungeon_size.x - 2) # Offset so the portals don't spawn on the edges
	var y = rng.randi_range(1, dungeon_size.y - 2) # Offset so the portals don't spawn on the edges

	# Check if tile is valid
	if map_state[x][y] != map_states.TILE or map_state[x][y + 1] != map_states.TILE or map_state[x][y - 1] != map_states.TILE:
		return false
	elif map_state[x + 1][y] != map_states.TILE or map_state[x - 1][y] != map_states.TILE:
		return false

	# Calculate coord
	var coord = Vector2(x * 16 + 8, y * 16 + 8)

	# Spawn the entrance
	$Exit.position = Vector2(x * 16, y * 16)
	exit_set = true
	exit_point = (x * dungeon_size.x) + y
	map_state[x][y] = map_states.EXIT
	return true

# Checks if the path from both portals is valid
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
	var counts = get_prop_counts(gen_parameters, rng)

	# Spawn props
	for prop in props:
		while counts[prop] > 0:
			if spawn_prop(props[prop], rng):
				counts[prop] -= 1

# Gets amount of props to spawn of each type
func get_prop_counts(gen_parameters: Dictionary, rng: RandomNumberGenerator) -> Dictionary:
	return {
		"crate": rng.randi_range(3 + 1 * gen_parameters["current_level"], 3 + 1 * gen_parameters["current_level"])
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
	var counts = get_enemy_counts(gen_parameters, rng)
	
	# Spawn enemies
	for enemy in enemies:
		while counts[enemy] > 0:
			if spawn_enemy(enemies[enemy], rng, enemies_sizes[enemy]):
				counts[enemy] -= 1

# Gets amount of enemies to spawn of each type
func get_enemy_counts(gen_parameters: Dictionary, rng: RandomNumberGenerator) -> Dictionary:
	return {
		"grunt": rng.randi_range(1 + 1 * gen_parameters["current_level"], 1),
		"masked_grunt": rng.randi_range(1 + 1 *gen_parameters["current_level"], 1),
		"paint_grunt": rng.randi_range(1 + 1 *gen_parameters["current_level"], 1),
		"zombie": rng.randi_range(1 + 1 *gen_parameters["current_level"], 1),
		"big_grunt": rng.randi_range(1 + 1 *gen_parameters["current_level"], 1),
		"elite": 2
	}

var bosscreator = BossCreator.new()

# Spawns a specific enemy instance
func spawn_enemy(type: PackedScene, rng: RandomNumberGenerator, big = false) -> bool:
	# Get enemy pos
	var x: int
	var y: int

	# Check if tile is valid
	if not big:
		x = rng.randi_range(0, dungeon_size.x - 1)
		y = rng.randi_range(0, dungeon_size.y - 1)

		if map_state[x][y] != map_states.TILE:
			return false
	else:
		x = rng.randi_range(1, dungeon_size.x - 2)
		y = rng.randi_range(1, dungeon_size.y - 2)

		if map_state[x][y] != map_states.TILE or map_state[x][y + 1] != map_states.TILE or map_state[x][y - 1] != map_states.TILE:
			return false
		elif map_state[x + 1][y] != map_states.TILE or map_state[x - 1][y] != map_states.TILE:
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
