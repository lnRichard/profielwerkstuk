extends ProjectileEntity


func _ready():
	$AnimatedSprite.play("default"); 


# _speed: float, _lifetime: int, _damage: float, _cooldown: int
func _init().(100, 2000, 0, 30):
	pass

func _on_Projectile_body_entered(body):
	._on_Projectile_body_entered(body)
	if body is Player:
		body.knockback = Vector2.RIGHT.rotated($AnimatedSprite.rotation) * 100;
		body.friction = -2000;
	elif body is HostileEntity:
		body.knockback = global_position.direction_to(body.global_position).normalized() * 100
		body.friction = 0;	
	
