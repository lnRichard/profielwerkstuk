extends KinematicBody2D

# Player Attribbutes
export var speed = 100; # walk speed
export var max_hp = 100.0;
export var hp = 100.0;
export var dash_speed = 250; # dash distance/speed
export var dash_cooldown = 60; # 0.5 second cooldown

# Variables associated with the dash ability
var dashing = false;
var current_dash_cooldown = 0
var v = Vector2();
var count = 10;
var time = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	if current_dash_cooldown > 0:
		current_dash_cooldown -=1
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_just_pressed("shift") && current_dash_cooldown == 0:
		$AnimatedSprite.stop(); # Temporary because no dash animation atm, probably add celeste like dash effect? 
		current_dash_cooldown = dash_cooldown;
		dashing = true;
		count = 0;
		v = Vector2(dash_speed, 0).rotated(get_local_mouse_position().angle());
		
	if count < 10:
		count+=1;
		move_and_collide(v*delta);
		$AnimatedSprite.flip_h = v.x < 0;
	else:
		dashing = false
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play("running")
		$AnimatedSprite.flip_h = velocity.x < 0;

	else:
		$AnimatedSprite.play("default")
	move_and_collide(velocity * delta)
