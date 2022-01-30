extends Area2D
class_name ProjectileEntity

# Generic
var speed: float # Speed of the projectile
var lifetime: int # How long the projectile may live
var damage: float # Damage of projectile
var cooldown: float # Cooldown of projectile

# _physics_process()
var ticks := 0 # How long the projectile has been alive

# move()
var direction := Vector2() # Moving direction of projectile

# Initialize the projectile
func _init(_speed: float, _lifetime: int, _damage: float, _cooldown: float):
	speed = _speed
	lifetime = _lifetime
	damage = _damage
	cooldown = _cooldown

# Projectile physics
func _physics_process(delta: float):
	ticks += 1

	# Kill the projectile if it has lived for too long
	if ticks > lifetime:
		queue_free()

	# Move the projectile
	move(delta)

# Moves the projectile position
func move(delta: float):
	position += direction * speed * delta

# Generic projectile behavior
func _on_Projectile_body_entered(body: CollisionObject2D):
	if body is LivingEntity:
		# If living entity deal damage
		body.friction = 200
		body.set_health(body.get_health() - damage)
		if damage != 0:
			queue_free()
	else:
		queue_free()
