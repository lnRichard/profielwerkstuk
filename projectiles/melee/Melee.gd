extends ProjectileEntity


func _ready():
	$AnimatedSprite.play("default"); 


# _speed: float, _lifetime: int, _damage: float, _cooldown: int
func _init().(0, 50, 20, 60):
	pass

func _on_Projectile_body_entered(body):
	._on_Projectile_body_entered(body)
	if body is LivingEntity:
		body.knockback = global_position.direction_to(body.global_position).normalized() * 30
