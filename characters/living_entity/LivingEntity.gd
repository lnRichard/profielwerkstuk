extends KinematicBody2D
class_name LivingEntity

var max_health;
var current_health;

var move_speed;
var velocity

enum {IDLING, MOVING, ATTACKING, DASHING}

var state = IDLING;


func _ready():
	pass

func _init(_max_health: float):
	max_health = _max_health;
	current_health = _max_health;


func change_health_minus(value: float):
	current_health-=value;
	
