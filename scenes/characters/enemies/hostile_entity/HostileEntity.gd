extends KinematicBody2D


var player;

export (float) var base_health;
export (float) var health;
export (float) var base_speed;
export (float) var base_damage;
export (float) var base_agility;
export (float) var base_shield;

export (float) var base_sight;

export (float) var base_multiplier = 1.0;

enum {IDLE, CHASING, ATTACKING}

var state = IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_Sight_body_entered(body):
	if (body.name == "Player"):
		player = body
		state = CHASING;

func _on_Sight_body_exited(body):
	if (body.name == "Player"):
		player = body;
		state = IDLE;
func apply_multiplier(multiplier: float):
	base_health*=multiplier;
	base_damage*=multiplier;
	base_shield*=multiplier;

func apply_sight(sight: float):
	get_node("Sight/Radius").scale*=sight;
	
func apply_damage(value: float):
	health-=value;
