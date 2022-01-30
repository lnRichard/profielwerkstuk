extends LivingEntity
class_name HostileEntity

# Generic
var rng := RandomNumberGenerator.new() # RNG instance
var player: Player # Reference to the player
var score: int # Score value the enemy awards
var xp: int # Xp the enemy awards

# Move()
onready var space_state := get_world_2d().direct_space_state # State of the map
var player_hidden := false # If the enemy can see the player

# Attack()
var target := Vector2(0, 0) # Target for new path gen
var pathSpeed := 1 # Speed for current path
var count := 0 # Count towards new path gen

# Idle()
var point := Vector2.ZERO
var moving := false
var idle_timeout := 120

# On enemy creation
func _init(_max_health: float, _move_speed: float, _score: int).(_max_health, _move_speed):
	# TODO: Fix bug where "LoadArea" does not follow camera due to limits
	rng.randomize()
	xp = _score
	score = _score
	state = UNLOADED

# Updates enemy physics
func _physics_process(delta: float):
	cooldowns()
	ai(delta)

func _ready():
	$AnimatedSprite.play("idle")

# ENEMY LOGIC

# Handles the enemy AI
func ai(delta: float):
	match state:
		MOVING:
			move()
		ATTACKING:
			attack()
		IDLING:
			idle()
		FROZEN:
			frozen(delta)
		UNLOADED:
			return
	
	# Call parent
	._physics_process(delta)

# Currently in non-astar form
func move():
	count += 1

	# Idle when player is not seen
	if player_hidden:
		# Check if player is seen again
		if count == 60:
			player_hidden = visual_check()
			count = 0

		idle()
		return
	
	# Player doesn't exist
	elif not player:
		state = IDLING
		return

	# Detects if new path towards player should be generated
	if count == 60:
		player_hidden = visual_check()
		target = global_position.direction_to(player.global_position)
		pathSpeed = rng.randi_range(0, 30)
		count = rng.randi_range(0, 30)

	# Moves enemy towards player
	$AnimatedSprite.flip_h = target.x < 0
	$AnimatedSprite.play("running")
	move_and_slide(target * (30 + pathSpeed))

# Checks if the enemy can see the player
func visual_check() -> bool:
	var result = space_state.intersect_ray(global_position, player.global_position, [self], collision_mask)
	return result and not result is Player

# Enemy-specific override function
func attack():
	pass

# Enemy-specific override function
func cooldowns():
	pass

# move between two spots 
func idle():
	idle_timeout += 1
	# Checks if a new idle state should be generated
	if idle_timeout >= 120:
		idle_timeout = 0

		# Checks if the idle state is moving or not
		if rng.randi_range(1, 8) <= 7:
			$AnimatedSprite.play("running")
			point = global_position + Vector2(rng.randi_range(-20, 20), rng.randi_range(-20, 20))
			moving = true
		else:
			$AnimatedSprite.play("idle")
			moving = false

	# Moving idle state
	if moving:
		$AnimatedSprite.play("running")
		var v = global_position.direction_to(point)
		$AnimatedSprite.flip_h = v.x < 0
		
		# Timeout idle state when target point has been reached [WARNING: Causing lag?]
		if global_position.distance_to(point) <= 5:
			idle_timeout = 120

		# Return the velocity
		move_and_slide(v * 50)
	else:
		# Stand still and idle
		$AnimatedSprite.play("idle")

# Called if the enemy is frozen
func frozen(delta: float):
	$AnimatedSprite.modulate = frozen_color
	freeze_time -= delta

	# Remove freeze effect if timer is over
	if freeze_time <= 0:
		update_redness()
		$AnimatedSprite.play("running")
		state = IDLING
		freeze_time = 0


# PLAYER DETECTION AND STATE MANAGEMENT

# Called using player collision player
func _on_Sight_body_entered(body: Player):
	# Do not move when frozen
	if state != FROZEN:
		player_hidden = false
		player = body
		state = MOVING

# Called using player collision player
func _on_Sight_body_exited(body: Player):
	# Do not idle when frozen
	if state != FROZEN:
		state = IDLING
		player = null

# Called using player collision player
func _on_Attack_body_entered(body: Player):
	# Do not attack if frozen
	if state != FROZEN:
		player = body
		state = ATTACKING
		$AnimatedSprite.play("idle")

# Called using player collision player
func _on_Attack_body_exited(_body: Player):
	# Do not attack if frozen
	if state != FROZEN:
		state = MOVING
		$AnimatedSprite.play("running")		


# MISC FUNCTIONS

# Set the health of the entity to a specific value
func set_health(value: float):
	.set_health(value)

	# Check if the enemy is dead
	if current_health <= 0:
		death_effect()
		Global.highscore += score
		Global.xp = Global.xp + xp
		queue_free()
	else:
		update_healthbar()
		$AnimatedSprite.modulate = Color(1, 0, 0)
		$Tween.interpolate_callback(self, 0.1, "untint")
		$Tween.start()

# Remove enemy tint
func untint():
	if state != FROZEN:
		update_redness()
	else:
		$AnimatedSprite.modulate = frozen_color

# Updatestint of the enemy
func update_redness():
	# Calculate enemy tint
	var redness = 0
	if current_health <= 0:
		redness = 0.5
	elif current_health == max_health:
		redness = 1
	else:
		redness = max_health / current_health
		if redness < 0.5:
			redness = 0.5

	# Change enemy color
	$AnimatedSprite.modulate = Color(redness, 1, 1, 1)

# Updates the healthbar of the entity
func update_healthbar():
	# Modify progressbar
	if max_health <= 0:
		$ProgressBar.value = 0
	else:
		$ProgressBar.value = current_health/max_health * 100
