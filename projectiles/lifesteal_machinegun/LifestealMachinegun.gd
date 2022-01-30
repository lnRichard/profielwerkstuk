extends ProjectileEntity
class_name LifestealMachinegun
var player;
# Initialize lifestealmachinegun projectile
func _ready():
	$AnimatedSprite.play("default") 

# _speed: float, _lifetime: int, _damage: float, _cooldown: int
func _init().(100, 2000, 1, 0):
	pass

# Override logic function
func _on_Projectile_body_entered(body):
	._on_Projectile_body_entered(body)
	if body is LivingEntity:
		body.knockback = global_position.direction_to(body.global_position).normalized() * 50
		if is_instance_valid(player):
			player.current_health+=1;
	
