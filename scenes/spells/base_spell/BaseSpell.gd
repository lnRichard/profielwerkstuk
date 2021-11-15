extends KinematicBody2D


export (float) var damage;
export (float) var stun;
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


func _on_Area2D_body_entered(body):
	print(body.name);
