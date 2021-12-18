extends LivingEntity
class_name Player


var last_direction = Vector2();

var dash = {
	"speed": 20,
	"cooldown": 30,
	"c_cooldown": 0,
	"range": 10,
	"duration": 0
}

var projectile = {}

enum ATTACK_SLOT {NONE, A, B, C, D, E, F, G}

func _init().(20, 3):
	pass
func _ready():
	$AnimatedSprite.play("idle")
 
func _physics_process(delta):
	if Input.is_action_just_pressed("key_e"):
		attack();
	match state:
		IDLING:
			idle()
		DASHING:
			pass;
		MOVING:
			move();
		ATTACKING:
			attack();

func move():
	var velocity = movement_input()
	if velocity.length() == 0:
		state = IDLING
		$AnimatedSprite.play("idle");
	else:
		last_direction = velocity;
		move_and_collide(velocity * move_speed); 
		$AnimatedSprite.flip_h = (velocity.x < 0 && velocity.x != 0);
		
		
func idle():
	var velocity = movement_input();
	if velocity.length() != 0:
		state = MOVING;
		$AnimatedSprite.play("running");


func dash():
	move_and_collide(last_direction * dash.speed);
	dash.duration+=1;
	if dash.duration >= dash.range:
		state = IDLING;
		dash.duration = 0;	
		
func attack():
	# TEMPORARY
	var b = preload("res://projectiles/fireball/Fireball.tscn").instance();
	b.direction = Vector2(10, 0).rotated((get_local_mouse_position()).angle()).normalized()
	b.get_node("AnimatedSprite").rotation = get_local_mouse_position().angle()
	b.position = $AttackPoint.position
	get_parent().add_child(b);
	

func movement_input() -> Vector2:
	if Input.is_action_just_pressed("space"):
		state=DASHING
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
		return ATTACK_SLOT.A ;
	elif Input.is_action_just_pressed("left_click"):
		return ATTACK_SLOT.B;
	elif Input.is_action_just_pressed("key_e"):
		return ATTACK_SLOT.C
	elif Input.is_action_just_pressed("key_q"):
		return ATTACK_SLOT.D
	else:
		return ATTACK_SLOT.NONE
		
		
func cooldowns():
	dash.c_cooldown-=1;
	
