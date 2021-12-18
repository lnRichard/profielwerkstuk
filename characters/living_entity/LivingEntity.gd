extends KinematicBody2D
class_name LivingEntity

var max_health;
var current_health setget set_health, get_health;

var move_speed;
var velocity

enum {IDLING, MOVING, ATTACKING, DASHING}

var state = IDLING;


func _ready():
	pass

func _init(_max_health: float, _move_speed: float):
	max_health = _max_health;
	current_health = _max_health;
	move_speed = _move_speed;


func set_health(value: float):
	current_health=value;
	
func get_health() -> float:
	return current_health;
	

func attack():
	pass
