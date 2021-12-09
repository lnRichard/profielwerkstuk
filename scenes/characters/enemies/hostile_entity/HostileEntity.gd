extends KinematicBody2D
class_name HostileEntity

var player;

export (int) var weight;

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
func _init(_base_health: float, _base_speed: float,
 _base_damage: float, _base_sight,  _base_multiplier: float, _weight: int):
	base_health = _base_health;
	health = base_health
	base_speed = _base_speed
	base_damage = _base_damage;
	base_sight = _base_sight;
	base_multiplier = _base_multiplier;
	weight = _weight

func _physics_process(delta):
	if health < 1:
		queue_free()
func _on_Sight_body_entered(body):
	if (body.name == "Player"):
		player = body
		state = CHASING;

func _on_Sight_body_exited(body):
	if (body.name == "Player"):
		player = body;
		state = IDLE;
func apply_multiplier():
	base_health*=base_multiplier;
	base_damage*=base_multiplier;
	base_shield*=base_multiplier;

func apply_sight():
	get_node("Sight/Radius").scale*=base_sight;
	
func apply_damage(value: float):
	health-=value;
