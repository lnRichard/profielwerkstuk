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
	
func _ready():
	$Label.text = String(damage);

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
		body.set_health(body.get_health() - damage);
		_damage_indicator();
	else:
		queue_free()

func _damage_indicator():
	$Label.visible = true;
	var tween = get_node("Tween");
	tween.interpolate_callback(self, 1.5, "queue_free")
	set_physics_process(false)
	$Collision.queue_free()
	$AnimatedSprite.visible = false;
	tween.start();
	
func _on_Projectile_body_exited(body):
	pass


