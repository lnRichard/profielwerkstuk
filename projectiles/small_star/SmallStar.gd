extends ProjectileEntity


var targets = [];

# _speed: float, _lifetime: int, _damage: float, _cooldown: int
func _init().(100, 2000, 200, 30):
	pass
	
func _ready():
	pass 



func _on_ExplosionArea_body_exited(body):
	targets.remove(targets.bsearch(body));

func _on_ExplosionArea_body_entered(body):
	targets.append(body)

func _on_Projectile_body_entered(body):
	for t in targets:
		if is_instance_valid(t):
			t.friction = 200;			
			t.set_health(t.get_health() - damage);
	queue_free()
