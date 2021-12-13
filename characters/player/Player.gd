extends LivingEntity
class_name Player


var last_direction = Vector2();


enum ATTACK_SLOT {NONE, A, B, C, D, E, F, G}


func _ready():
	pass 

func _physics_process(delta):
	match state:
		IDLING:
			idle()
		DASHING:
			pass;
		MOVING:
			move();
		ATTACKING:
			pass

func move():
	var velocity = movement_input()
	if velocity.length() == 0:
		state = IDLING
		$AnimatedSprite.play("idle");
	else:
		last_direction = velocity;
		move_and_collide(velocity);
		$AnimatedSprite.flip_h = velocity.x > 0;
		
		
func idle():
	var velocity = movement_input();
	if velocity.length() != 0:
		state = MOVING;
		$AnimatedSprite.play("running");









func movement_input() -> Vector2:
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

func attack_input():
	if Input.is_action_just_pressed("right_click"):
		return ATTACK_SLOT.A;
	elif Input.is_action_just_pressed("left_click"):
		return ATTACK_SLOT.B;
	elif Input.is_action_just_pressed("key_e"):
		return ATTACK_SLOT.C
	elif Input.is_action_just_pressed("key_q"):
		return ATTACK_SLOT.D
	else:
		return ATTACK_SLOT.NONE
