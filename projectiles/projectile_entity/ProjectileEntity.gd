extends Area2D
class_name ProjectileEntity

var speed;
var lifetime;
var damage;
var cooldown;
var direction = Vector2();

var ticks = 0;


func _init(_speed: float, _lifetime: int, _damage: float, _cooldown: float):
	speed = _speed;
	lifetime = _lifetime;
	damage = _damage;
	cooldown = _cooldown
	

func _physics_process(delta):
	ticks+=1;
	if ticks > lifetime:
		queue_free()
	move(delta);
	

# https://kidscancode.org/godot_recipes/2d/2d_shooting/
func move(delta):
	position += direction * speed * delta;
	
# default behaviour override if neccesarry 
func _on_Projectile_body_entered(body):
	if body is LivingEntity:
		body.friction = 200;
		body.set_health(body.get_health() - damage);
		if damage != 0:
			_damage_indicator(body.get_health() <= 0);
	else:
		queue_free()

func _damage_indicator(killing_blow: bool):
	queue_free()
	var label = preload("res://projectiles/damage_indicator/DamageIndicator.tscn").instance();
	label.get_node("Label").text = String(damage);
	label.global_position = global_position;
	get_parent().add_child(label)
	label.show_value(killing_blow)
func _on_Projectile_body_exited(body):
	pass


