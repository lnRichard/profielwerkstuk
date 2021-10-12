extends KinematicBody2D

export var speed = 100;
export var max_hp = 100.0;
export var hp = 100.0;
export var attack = 10;


# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false);
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	pass
	

