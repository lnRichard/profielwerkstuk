extends KinematicBody2D
class_name LivingEntity

var max_health;
var current_health setget set_health, get_health;

var move_speed;
var velocity

enum {IDLING, MOVING, ATTACKING, DASHING, FROZEN}

var state = IDLING;
var immortal = false;
var frozen = false;

func _ready():
	pass

func _init(_max_health: float, _move_speed: float):
	max_health = _max_health;
	current_health = _max_health;
	move_speed = _move_speed;

var delta;


var knockback = Vector2.ZERO;
var friction = 200;
func knockback(delta):
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	knockback = move_and_slide(knockback)
	
func _physics_process(delta):
	knockback(delta)

# Override this function
func freeze(time: float):
	pass

func set_health(value: float):
	if immortal:
		return
	else:
		current_health = value;
func get_health() -> float:
	return current_health;
	

func attack():
	pass


func spawn_death():
	var death = preload("res://characters/living_entity/death/DeathEffect.tscn").instance();
	death.global_position = global_position;
	get_parent().add_child(death)
	death.get_node("DeathEffect").play()


