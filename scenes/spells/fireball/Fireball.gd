extends "../base_spell/BaseSpell.gd"


# Called when the node enters the scene tree for the first time.
func _init().(1000, 10, 30, 1, 5*60, 1):
	pass

func _ready():
	var cooldown = 1000;
	damage = 10
	stun = 30
	speed = 0.5
	lifetime = 5*60;
	size;
	print(cooldown)
func _physics_process(delta):
	move_and_collide(direction * speed);
