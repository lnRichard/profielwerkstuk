extends KinematicBody2D

enum {IDLE, WALKING, DASHING, ATTACKING}
export var speed := 3; # walk speed

export var max_hp := 100.0;
export var hp := 100.0;




var state = IDLE;

var last_direction = Vector2();
export var dash_speed := 15
export var dash_cooldown :=30;
export var dash_current_cooldown := 30; # 30 frames;
export var dash_range := 10 # 30 frames;
export var dash_duration := 0; # duration of ongoing dash


var ability_rc = "res://scenes/spells/fireball/Fireball.tscn"
var ability_lc;
var ability_r;
var ability_f;

onready var room = get_parent();

func _ready():
	pass


func _process(delta):
	pass


func _physics_process(delta):
	# PROTOTYPE FOR CASTING SPELLS
	# IDEA IS TO ADD VARIABLES WHICH ARE THE PATHS TO THE FIREBALLS WHICH WILL BE INSTANTIATED
	# COOL DOWN CAN BE CHECKED 
	
	if clicked():
		var instance = load(ability_rc).instance();
		instance.direction = Vector2(10, 0).rotated(get_local_mouse_position().angle());
		instance.position = position;
		room.add_child(instance); # So that it's not relative to the player
	var velocity = Vector2();
	dash_current_cooldown-=1;
	if Input.is_action_just_pressed("ui_accept") && dash_current_cooldown <= 0:
		dash_current_cooldown = dash_cooldown # reset;
		state = DASHING;
	match state:
		IDLE:
			$AnimatedSprite.play("default")
			velocity = input();
			if (velocity.length() > 0):
				state = WALKING;
		WALKING:
			$AnimatedSprite.play("running")
			velocity = input();
			if (velocity.length() == 0):
				state = IDLE;
			else:
				last_direction = velocity; # for dash
				move_and_collide(velocity * speed)
				$AnimatedSprite.flip_h = velocity.x < 0;
		DASHING:
			move_and_collide(last_direction * dash_speed);
			dash_duration+=1;
			if dash_duration >= dash_range:
				state = IDLE;
				dash_duration = 0;
		ATTACKING:
			pass
	
#	# Determine which way to show sprite	
#	if velocity.length() > 0:
#		velocity = velocity.normalized() * speed
#
		
#

func clicked() -> bool:
	return Input.is_action_just_pressed("shift")
	
func input() -> Vector2:
	var velocity = Vector2();
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	return velocity.normalized();
