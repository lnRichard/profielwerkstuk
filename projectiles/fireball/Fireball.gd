extends ProjectileEntity


# Initialize fireball projectile
func _ready():
	$AnimatedSprite.play("default") 

# _speed: float, _lifetime: int, _damage: float, _cooldown: int
func _init().(100, 2000, 20, 30):
	pass

# Override logic function
func _on_Projectile_body_entered(body: CollisionObject2D):
	._on_Projectile_body_entered(body)

	# Unfreeze frozen entities and knockback
	if body is LivingEntity:
		body.knockback = global_position.direction_to(body.global_position).normalized() * 100
		body.freeze_time = 0.0
