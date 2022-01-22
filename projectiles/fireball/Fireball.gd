extends ProjectileEntity


func _ready():
	$AnimatedSprite.play("default"); 


# _speed: float, _lifetime: int, _damage: float, _cooldown: int
func _init().(100, 2000, 20, 30):
	pass

