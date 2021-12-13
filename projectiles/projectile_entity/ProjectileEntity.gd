extends Area2D
class_name ProjectileEntity

var speed;
var lifetime;
var damage;


func _init(_speed: float, _lifetime: int, _damage: float):
	speed = _speed;
	lifetime = _lifetime;
	damage = _damage;
	

func _physics_process(delta):
	move(delta);
	

# https://kidscancode.org/godot_recipes/2d/2d_shooting/
func move(delta):
	position += transform.x * speed * delta;

# default behaviour override if neccesarry 
func _on_Projectile_body_entered(body):
	body.change_health_minus(damage * (body is LivingEntity))
	queue_free();


func _on_Projectile_body_exited(body):
	pass
