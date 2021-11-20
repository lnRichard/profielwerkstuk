extends "../base_spell/BaseSpell.gd"


# Called when the node enters the scene tree for the first time.
func _init().(30, 10, 30, 0.5, 20, 1):
	pass

func _ready():
	pass	
func _physics_process(delta):
	lifetime-=1
	if lifetime < 0:
		queue_free()
	move_and_collide(direction * speed);
