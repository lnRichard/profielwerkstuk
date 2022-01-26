extends KinematicBody2D
class_name LivingEntity

var max_health;
var current_health setget set_health, get_health;

var move_speed;
var velocity

enum {IDLING, MOVING, ATTACKING, DASHING}

var state = IDLING;
var immortal = false;
var frozen = false;

func _ready():
	pass

func _init(_max_health: float, _move_speed: float):
	max_health = _max_health;
	current_health = _max_health;
	move_speed = _move_speed;


func freeze(time: float):
	$AnimatedSprite.stop();
	set_physics_process(false);
	yield(get_tree().create_timer(time), "timeout")	
	set_physics_process(true)
	$AnimatedSprite.play("moving")	

func set_health(value: float):
	if immortal:
		return
	else:
		current_health = value;
func get_health() -> float:
	return current_health;
	

func attack():
	pass



