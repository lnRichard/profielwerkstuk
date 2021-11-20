extends KinematicBody2D

export (int) var cooldown;
export (float) var damage;
export (int) var stun;
export (float) var speed;
export (int) var lifetime;
export (int) var size;
var direction;
var start = 0;

func _ready():
	$AnimatedSprite.hide();
	
func _physics_process(delta):
	if start==3:
		$AnimatedSprite.show()
	else:
		start+=1;

func _init(_cooldown: int, _damage: float, _stun: int, _speed: float, _lifetime: int, _size: int):
	cooldown = _cooldown;
	damage = _damage;
	stun = _stun;
	speed = _speed
	lifetime = _lifetime
	size = _size

func _on_Area2D_body_entered(body):
	if (body.name == "HostileEntity"):
		body.apply_damage(damage);
