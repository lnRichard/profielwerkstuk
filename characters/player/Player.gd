extends LivingEntity
class_name Player

# States
enum ATTACK_SLOT {A, B, C, D, E, F, G} # Slots of attacking
signal PlayerDeath # Signals if player has died

# Generic
onready var parent := get_parent() # Parent

# Attack()
onready var space_state := get_world_2d().direct_space_state # State of the map
var projectiles := {} # Dict of projectiles
var projectile_queue # Projectile queue

# Dash()
var last_direction = Vector2() # Last move direction
var dash = {
	"speed": 20,
	"cooldown": 60,
	"c_cooldown": 0,
	"range": 5,
	"duration": 0
}


# Initializes the player
func _init().(100, 3):
	pass

# Initializes the player
func _ready():
	# Adds spells to the arsenal
	add_spell_arsenal("res://projectiles/fireball/Fireball.tscn", ATTACK_SLOT.A)
	add_spell_arsenal("res://projectiles/iceball/Iceball.tscn", ATTACK_SLOT.B)
	add_spell_arsenal("res://projectiles/small_star/SmallStar.tscn", ATTACK_SLOT.C)
	add_spell_arsenal("res://projectiles/lifesteal_machinegun/LifestealMachinegun.tscn", ATTACK_SLOT.D)
	add_spell_arsenal("res://projectiles/zippy_zip/ZippyZip.tscn", ATTACK_SLOT.E)
	$AnimatedSprite.play("idle")
	connect("PlayerDeath", get_parent(), "_game_over")

# Player physics
func _physics_process(delta: float):
	._physics_process(delta)
	cooldowns()
	movement(delta)


# INPUTS

# Movement
func movement_input() -> Vector2:
	if Input.is_action_just_pressed("space") && dash.c_cooldown == 0:
		$AnimatedSprite.play("idle")
		start_dash()
	var velocity = Vector2()
	if Input.is_action_pressed("key_d"):
		velocity.x += 1
	if Input.is_action_pressed("key_a"):
		velocity.x -= 1
	if Input.is_action_pressed("key_s"):
		velocity.y += 1
	if Input.is_action_pressed("key_w"):
		velocity.y -= 1
	return velocity.normalized()

# Attacking
func attack_input():
	if Input.is_action_just_pressed("right_click"):
		projectile_queue = ATTACK_SLOT.A
		state = ATTACKING
	elif Input.is_action_just_pressed("left_click"):
		projectile_queue = ATTACK_SLOT.B
		state = ATTACKING
	elif Input.is_action_just_pressed("key_f"):
		projectile_queue = ATTACK_SLOT.C
		state = ATTACKING
	elif Input.is_action_just_pressed("key_r"):
		projectile_queue = ATTACK_SLOT.D
		state = ATTACKING
	elif Input.is_action_just_pressed("key_e"):
		projectile_queue = ATTACK_SLOT.E
		state = ATTACKING


# MOVEMENT

# Handles player movement
func movement(delta: float):
	match state:
		IDLING:
			idle()
			attack_input()
		DASHING:
			dash()
		MOVING:
			move()
			attack_input()
		ATTACKING:
			attack()
			state=MOVING
		FROZEN:
			frozen(delta)

# The player is moving
func move():
	var input = movement_input()

	# Check if there is an input
	if input.length() == 0:
		state = IDLING
		$AnimatedSprite.play("idle")
	else:
		last_direction = input
		move_and_slide(input * move_speed * 50) 
		$AnimatedSprite.flip_h = (input.x < 0 && input.x != 0)

# The player is not moving
func idle():
	var input = movement_input()

	# Check if there is an input
	if input.length() != 0:
		state = MOVING
		$AnimatedSprite.play("running")

# The player is dashing
func dash():
	if dash.duration >= dash.range:
		# Player dash has completed
		state = IDLING
		dash.duration = 0	
		dash.c_cooldown = dash.cooldown
		$BodyCollision.scale = Vector2(1, 1)
		invulnerable=false
		$DashParticles.emitting = false
	elif dash.c_cooldown > 0:
		# Dash is on cooldown
		return
	else:
		# Player is dashing
		move_and_slide(50 * last_direction * dash.speed)
		dash.duration += 1

# The player has started ashing
func start_dash():
	state = DASHING
	$DashParticles.emitting = true
	invulnerable = true
	$BodyCollision.scale = Vector2(0.1, 0.1)

# The player is attacking
func attack():	
	# Check if there is an attack in the queue
	if projectile_queue in projectiles && projectiles[projectile_queue].c_cooldown == 0:
		projectiles[projectile_queue].c_cooldown = projectiles[projectile_queue].cooldown
		var b = projectiles[projectile_queue].projectile.instance()
		b.direction = Vector2.RIGHT.rotated((get_local_mouse_position()).angle()).normalized()
		b.get_node("AnimatedSprite").rotation = get_local_mouse_position().angle()
		b.position = $AttackPoint.position
		
		#Lifestealmachinegun
		if b is LifestealMachinegun:
			b.caster = self;
		
		# Perform raycast
		var result = space_state.intersect_ray(global_position, b.global_position, [self], 0b00000000000000000001)
		if result:
			# Hit invalid spot
			b.queue_free()
			return

		# Add to parent
		parent.add_child(b)

# The player is frozen
func frozen(delta: float):
	$AnimatedSprite.modulate = frozen_color
	freeze_time -= delta
	
	# Check if the player is not longer frozen
	if freeze_time <= 0:
		$AnimatedSprite.modulate = Color(1, 1, 1, 1)
		$AnimatedSprite.play("running")
		state = MOVING
		freeze_time = 0


# MISC

# Handle player cooldowns
func cooldowns():
	if dash.c_cooldown > 0:
		dash.c_cooldown -= 1
	for c in projectiles.values():
		if c.c_cooldown > 0:
			c.c_cooldown -= 1

# Add spell the the player's arsenal
func add_spell_arsenal(projectile_path: String, slot: int):
	var temp = load(projectile_path).instance()
	var cooldown = temp.cooldown
	temp.queue_free()
	
	# Add new projectile to it's slot
	projectiles[slot] = {
		"projectile": load(projectile_path),
		"cooldown": cooldown,
		"c_cooldown": 0
	}

# Set the player's health
func set_health(value: float):
	.set_health(value)
	health()

	death()	
	if value < current_health:
		$AnimatedSprite.modulate = Color(1, 0, 0)
		$Tween.interpolate_callback(self, 0.1, "untint")
		$Tween.start()


# Remove player tint
func untint():
	$AnimatedSprite.modulate = Color(1, 1, 1)

# Set healthbar progress
func health():
	$UILayer/UI/HealthBar.value = current_health/max_health * 100

# Check if player has died
func death():
	if current_health <= 0:
		death_effect()
		emit_signal("PlayerDeath")
