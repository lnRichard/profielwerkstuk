extends Area2D
class_name ProjectileEntity

var speed;
var lifetime;
var damage;
var cooldown;
var direction = Vector2();


func _init(_speed: float, _lifetime: int, _damage: float, _cooldown: float):
	speed = _speed;
	lifetime = _lifetime;
	damage = _damage;
	cooldown = _cooldown
	

func _physics_process(delta):
	move(delta);
	

# https://kidscancode.org/godot_recipes/2d/2d_shooting/
func move(delta):
	position += direction * speed * delta;

# default behaviour override if neccesarry 
func _on_Projectile_body_entered(body):
	print(body.get_health())
	body.set_health(body.get_health() - (damage * ((body is LivingEntity) as int)));
	queue_free();


func _on_Projectile_body_exited(body):
	pass
