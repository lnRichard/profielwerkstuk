extends KinematicBody2D


var player;

export (float) var base_health;
export (float) var base_speed;
export (float) var base_damage;
export (float) var base_agility;
export (float) var base_shield;

export (float) var base_sight;

export (float) var base_multiplier = 1.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)


func _on_Sight_body_entered(body):
	if (body.name == "Player"):
		set_physics_process(true)
		$AnimatedSprite.play("running")
		player = body;


func _on_Sight_body_exited(body):
	if (body.name == "Player"):
		set_physics_process(false)
		$AnimatedSprite.play("idle")
		player = body;

func apply_multiplier(multiplier: float):
	base_health*=multiplier;
	base_damage*=multiplier;
	base_shield*=multiplier;

func apply_sight(sight: float):
	get_node("Sight/Radius").scale*=sight;
