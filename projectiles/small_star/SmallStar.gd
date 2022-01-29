extends ProjectileEntity

# [!] TODO: Fix bug where targets to not get appended when the projectile dies 
# before the target.append function is called

# _on_Projectile_body_entered()
var targets = [] # Targets that will get exploded on hit


# Initialize small star projectile
func _ready():
	# No animation
	pass

# _speed: float, _lifetime: int, _damage: float, _cooldown: int
func _init().(100, 2000, 200, 30):
	pass

# Entity is susceptible to the explosion
func _on_ExplosionArea_body_entered(body):
	targets.append(body)

# Entity is not longer susceptible to the explosion
func _on_ExplosionArea_body_exited(body):
	targets.remove(targets.bsearch(body))

# Override logic function
func _on_Projectile_body_entered(body):
	# Hits all entities in explosion radius
	for t in targets:
		# Checks if entity has not already died
		if is_instance_valid(t):

			# Update entity fiction and health
			t.friction = 200			
			t.set_health(t.get_health() - damage)
			
			# Spawn damage indicators
			if damage != 0:
				_damage_indicator(t.get_health() <= 0)
	queue_free()
