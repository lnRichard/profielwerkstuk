extends ProjectileEntity
class_name LifestealMachinegun

# _on_Projectile_body_entered()
var caster: LivingEntity # Entity which casted the spell
var heal_amount = 1 # Amount to heal


# Initialize lifestealmachinegun projectile
func _ready():
	$AnimatedSprite.play("default") 

# _speed: float, _lifetime: int, _damage: float, _cooldown: int
func _init().(50, 2000, 5, 10, 0.5):
	pass

# Override logic function
func _on_Projectile_body_entered(body):
	._on_Projectile_body_entered(body)
	if body is LivingEntity:
		body.knockback = global_position.direction_to(body.global_position).normalized() * 25
		if is_instance_valid(caster):
			caster.current_health += heal_amount
