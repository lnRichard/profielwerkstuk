extends ProjectileEntity




func _ready():
	$AnimatedSprite.play("default"); 


# _speed: float, _lifetime: int, _damage: float, _cooldown: int
func _init().(100, 2000, 200, 30):
	pass


func _on_Projectile_body_entered(body):
	if body is LivingEntity:
		body.set_health(body.get_health() - damage);
		body.freeze(3.0);
		_damage_indicator()
	else:
		queue_free()