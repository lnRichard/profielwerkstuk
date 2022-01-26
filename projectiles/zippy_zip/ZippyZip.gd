extends ProjectileEntity


func _ready():
	$AnimatedSprite.play("default"); 


# _speed: float, _lifetime: int, _damage: float, _cooldown: int
func _init().(100, 2000, 200, 30):
	pass


func move(delta):
	var x = position.x
	var y = 5 * abs(((int(x)-1) % 2) -4 ) -5
	position += (Vector2(0, y)) * speed * delta;
	
