extends Area2D
class_name ProjectileEntity

# Generic
var speed # Speed of the projectile
var lifetime # How long the projectile may live
var damage # Damage of projectile
var cooldown # Cooldown of projectile

# _physics_process()
var ticks = 0 # How long the projectile has been alive

# move()
var direction = Vector2() # Moving direction of projectile


# Initialize the projectile
func _init(_speed: float, _lifetime: int, _damage: float, _cooldown: float):
	speed = _speed
	lifetime = _lifetime
	damage = _damage
	cooldown = _cooldown

# Projectile physics
func _physics_process(delta):
	ticks += 1

	# Kill the projectile if it has lived for too long
	if ticks > lifetime:
		queue_free()

	# Move the projectile
	move(delta)

# Moves the projectile position
func move(delta):
	position += direction * speed * delta

# Generic projectile behavior
func _on_Projectile_body_entered(body):
	if body is LivingEntity:
		# If living entity deal damage
		body.friction = 200
		body.set_health(body.get_health() - damage)
		if damage != 0:
			# Spawn damage indicator
			_damage_indicator(body.get_health() <= 0)
	else:
		queue_free()

# Creates a damage indicator
func _damage_indicator(killing_blow: bool):
	queue_free()
	# Create the label
	var label = preload("res://projectiles/damage_indicator/DamageIndicator.tscn").instance()

	# Style the lobal
	label.get_node("Label").text = String(damage)
	label.global_position = global_position

	# Append the label
	get_parent().add_child(label)
	label.show_value(killing_blow)
