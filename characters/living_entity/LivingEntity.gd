extends KinematicBody2D
class_name LivingEntity

var max_health;
var current_health;

var move_speed;

enum {IDLING, MOVING, ATTACKING}

# Called when the node enters the scene tree for the first time.
func _ready():
	print(123)

func _init(_max_health: float):
	max_health = _max_health;
	current_health = _max_health;

func _physics_process(delta):
	move();
	

func move():
	pass
