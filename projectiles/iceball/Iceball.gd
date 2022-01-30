extends ProjectileEntity


# Initialize iceball projectile
func _ready():
	$AnimatedSprite.play("default") 

# _speed: float, _lifetime: int, _damage: float, _cooldown: int
func _init().(100, 2000, 15, 30):
	pass

# Override logic function 
func _on_Projectile_body_entered(body: CollisionObject2D):
	._on_Projectile_body_entered(body)

	# Freeze entity on hit
	if body is LivingEntity:
		body.freeze(3.0)
