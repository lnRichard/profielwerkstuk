extends LivingEntity
class_name Player

enum ATTACK_SLOT {A, B, C, D, E, F, G}

onready var parent = get_parent();
var last_direction = Vector2();

var dash = {
	"speed": 20,
	"cooldown": 60,
	"c_cooldown": 0,
	"range": 10,
	"duration": 0
}

var projectiles = {
	ATTACK_SLOT.A: load("res://projectiles/fireball/Fireball.tscn")
};

var projectile_queue;



func _init().(20, 3):
	pass
func _ready():
	$AnimatedSprite.play("idle")
 
func _physics_process(delta):
	cooldowns()
	match state:
		IDLING:
			idle()
			attack_input()
		DASHING:
			dash()
		MOVING:
			move();
			attack_input();
		ATTACKING:
			attack();
			state=MOVING

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
	if dash.duration >= dash.range:
		state = IDLING;
		dash.duration = 0;	
		dash.c_cooldown = dash.cooldown;
	elif dash.c_cooldown > 0:
		return
	else:
		move_and_collide(last_direction * dash.speed);
		dash.duration+=1;
		
func attack():
	if projectile_queue in projectiles:
		var b = projectiles[projectile_queue].instance();
		b.direction = Vector2(10, 0).rotated((get_local_mouse_position()).angle()).normalized()
		b.get_node("AnimatedSprite").rotation = get_local_mouse_position().angle()
		b.position = $AttackPoint.position
		parent.add_child(b);
	

func movement_input() -> Vector2:
	if Input.is_action_just_pressed("space"):
		$AnimatedSprite.play("idle")
		state=DASHING
	var velocity = Vector2();
	if Input.is_action_pressed("key_d"):
		velocity.x += 1
	if Input.is_action_pressed("key_a"):
		velocity.x -= 1
	if Input.is_action_pressed("key_s"):
		velocity.y += 1
	if Input.is_action_pressed("key_w"):
		velocity.y -= 1
	return velocity.normalized();

func attack_input():
	if Input.is_action_just_pressed("right_click"):
		projectile_queue = ATTACK_SLOT.A;
		state = ATTACKING
	elif Input.is_action_just_pressed("left_click"):
		projectile_queue = ATTACK_SLOT.B;
		state = ATTACKING
	elif Input.is_action_just_pressed("key_e"):
		projectile_queue = ATTACK_SLOT.C
		state = ATTACKING
	elif Input.is_action_just_pressed("key_q"):
		projectile_queue = ATTACK_SLOT.D
		state = ATTACKING
		
		
func cooldowns():
	if dash.c_cooldown > 0:
		dash.c_cooldown-=1;
	
