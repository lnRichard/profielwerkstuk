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

func _ready():
	$AnimatedSprite/Particles2D.hide();


func _process(delta):
	pass


func _physics_process(delta):
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
