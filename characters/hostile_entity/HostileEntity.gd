extends LivingEntity
class_name HostileEntity

# Generic
var rng = RandomNumberGenerator.new() # RNG instance
var freeze_time = 0 # Time the enemy has left being frozen
var player # Reference to the player
var score # Score value the enemy awards
var xp # Xp the enemy awards

# Attack()
var target = Vector2(0, 0) # Target for new path gen
var pathSpeed = 1 # Speed for current path
var count = 0 # Count towards new path gen

# Idle()
var point = global_position
var moving = false
var idle_timeout = 120


# On enemy creation
func _init(_max_health: float, _move_speed: float, _score: int).(_max_health, _move_speed):
	xp = _score
	score = _score
	state = UNLOADED

# Updates enemy physics
func _physics_process(delta):
	cooldowns()
	ai(delta)


# ENEMY LOGIC

# Handles the enemy AI
func ai(delta):
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
	# Initialize raycast
	var space_state = get_world_2d().direct_space_state

	# Check if player is not set
	if not player:
		return

	# Raycast
	var result = space_state.intersect_ray(global_position, player.global_position, [self], collision_mask)
	if result and not result is Player:
		# Did not detect player
		state = IDLING
		return

	count += 1
	# Detects if new path towards player should be generated
	if count == 60:
		target = global_position.direction_to(player.global_position)
		pathSpeed = rng.randi_range(0, 30)
		count = rng.randi_range(0, 30)

	# Moves enemy towards player
	$AnimatedSprite.flip_h = target.x < 0
	$AnimatedSprite.play("running")
	move_and_slide(target * (30 + pathSpeed))

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
		
		# Timeout idle state when target point has been reached
		if global_position.distance_to(point) <= 5:
			idle_timeout = 120

		# Return the velocity
		move_and_slide(v * 50)
	else:
		# Stand still and idle
		$AnimatedSprite.play("idle")

# Called if the enemy is frozen
func frozen(delta):
	$AnimatedSprite.modulate = Color(0, 0.6, 1, 1)
	freeze_time -= delta
	
	# Remove freeze effect if timer is over
	if freeze_time <= 0:
		set_health(current_health)
		$AnimatedSprite.play("running")
		state = IDLING
		freeze_time = 0


# PLAYER DETECTION AND STATE MANAGEMENT

# Called using player collision player
func _on_Sight_body_entered(body):
	player = body
	state = MOVING

# Called using player collision player
func _on_Sight_body_exited(_body):
	state = IDLING
	player = null

# Called using player collision player
func _on_Attack_body_entered(body):
	# Do not attack if frozen
	if state != FROZEN:
		player = body
		state = ATTACKING
		$AnimatedSprite.play("idle")

# Called using player collision player
func _on_Attack_body_exited(_body):
	# Do not attack if frozen
	if state != FROZEN:
		state = MOVING
		$AnimatedSprite.play("running")		


# MISC FUNCTIONS

# Set the health of the entity to a specific value
func set_health(value):
	.set_health(value)

	# Check if the enemy is dead
	if current_health <= 0:
		death_effect()
		Global.highscore+=score
		var main = get_parent().get_parent()
		main.xp = main.xp + xp
		queue_free()
	else:
		update_health()

func update_health():
	# Calculate enemy tint
	var redness = 0
	if current_health <= 0:
		redness = 0.5
	elif current_health == max_health:
		redness = 1
	else:
		redness = (max_health * 2) / current_health
		if redness < 0.5:
			redness = 0.5

	# Change enemy color
	$AnimatedSprite.modulate = Color(redness, 1, 1, 1)

	# Modify progressbar
	if max_health <= 0:
		$ProgressBar.value = 0
	else:
		$ProgressBar.value = current_health/max_health * 100

# Called when enemy is intially frozen
func freeze(time: float):
	$AnimatedSprite.stop()
	freeze_time = time
	state = FROZEN
