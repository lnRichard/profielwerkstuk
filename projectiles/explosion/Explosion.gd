extends ProjectileEntity

# _on_Projectile_body_entered()
var targets = [] # Targets that will get exploded on hit


# Initialize small star projectile
func _ready():
	# No animation
	pass

# _speed: float, _lifetime: int, _damage: float, _cooldown: int
func _init().(0, 2000, 1, 30):
	pass

# Target is susceptible to the explosion
func _on_ExplosionArea_body_entered(body: CollisionObject2D):
	targets.append(body)

# Target is not longer susceptible to the explosion
func _on_ExplosionArea_body_exited(body: CollisionObject2D):
	targets.remove(targets.bsearch(body))

func _physics_process(delta):
	._physics_process(delta)
	yield(get_tree().create_timer(1.0), "timeout")
	queue_free()
# Override logic function
func _on_Projectile_body_entered(body: CollisionObject2D):
#	yield(get_tree().create_timer(0.001), "timeout")
	# Hits all target in explosion radius
	for target in targets:

		# Checks if target has not been removed
		if is_instance_valid(target):

			# If target is an entity
			if target is LivingEntity:
				# Update entity fiction and health
				target.friction = 200			
				target.set_health(target.get_health() - damage)

			# If target is a destroyable
			elif target is Destroyable:
				# Destroy the prop
				target.destroy()
	queue_free()
