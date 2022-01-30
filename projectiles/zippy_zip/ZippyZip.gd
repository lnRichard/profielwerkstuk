extends ProjectileEntity


# Initialize the zippy zip projectile
func _ready():
	$AnimatedSprite.play("default"); 

# _speed: float, _lifetime: int, _damage: float, _cooldown: int
func _init().(100, 2000, 0, 30):
	pass

# Override logic function
func _on_Projectile_body_entered(body: CollisionObject2D):
	._on_Projectile_body_entered(body)
	
	# Check collision target
	if body is Player:
		# Launch player in projectile direction
		body.knockback = Vector2.RIGHT.rotated($AnimatedSprite.rotation) * 100;
		body.friction = -2000;
	elif body is HostileEntity:
		# Push enemies away
		body.knockback = global_position.direction_to(body.global_position).normalized() * 100
		body.friction = 0;	
