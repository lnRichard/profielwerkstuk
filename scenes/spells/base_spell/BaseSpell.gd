extends KinematicBody2D


export (float) var damage;
export (float) var stun;
export (float) var speed;

var direction;


func _ready():
	pass 


func _on_Area2D_body_entered(body):
	print(body.name);
