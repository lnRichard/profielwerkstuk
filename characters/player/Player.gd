extends LivingEntity
class_name Player

enum ATTACK_SLOT {A, B, C, D, E, F, G}



signal PlayerDeath;

onready var parent = get_parent();
var last_direction = Vector2();

var dash = {
	"speed": 20,
	"cooldown": 60,
	"c_cooldown": 0,
	"range": 5,
	"duration": 0
}

var projectiles = {};

var projectile_queue;

var freeze_time = 0



func _init().(100000, 3):
	pass
func _ready():
	add_spell_arsenal("res://projectiles/fireball/Fireball.tscn", ATTACK_SLOT.A)
	add_spell_arsenal("res://projectiles/iceball/Iceball.tscn", ATTACK_SLOT.B)
	add_spell_arsenal("res://projectiles/small_star/SmallStar.tscn", ATTACK_SLOT.C)
	add_spell_arsenal("res://projectiles/zippy_zip/ZippyZip.tscn", ATTACK_SLOT.D)
	$AnimatedSprite.play("idle")
	connect("PlayerDeath", get_parent(), "_game_over")

func _physics_process(delta):
	._physics_process(delta)
	cooldowns()
	health()
	death()
	match state:
		IDLING:
			idle()
			attack_input()
		DASHING:
			$DashParticles.emitting = true
			dash()
		MOVING:
			move();
			attack_input();
		ATTACKING:
			attack();
			state=MOVING
		FROZEN:
			frozen(delta)

func move():
	var velocity = movement_input()
	if velocity.length() == 0:
		state = IDLING
		$AnimatedSprite.play("idle");
	else:
		last_direction = velocity;
		move_and_slide(velocity * move_speed * 50); 
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
		$BodyCollision.scale = Vector2(1, 1)
		immortal=false;
		$DashParticles.emitting = false
	elif dash.c_cooldown > 0:
		return
	else:
		immortal = true;
		move_and_slide(50 * last_direction * dash.speed);
		dash.duration+=1;
		$BodyCollision.scale = Vector2(0.1, 0.1)
		
func attack():
	if projectile_queue in projectiles && projectiles[projectile_queue].c_cooldown == 0:
		projectiles[projectile_queue].c_cooldown = projectiles[projectile_queue].cooldown;
		var b = projectiles[projectile_queue].projectile.instance();
		b.direction = Vector2(10, 0).rotated((get_local_mouse_position()).angle()).normalized()
		b.get_node("AnimatedSprite").rotation = get_local_mouse_position().angle()
		b.position = $AttackPoint.position
		parent.add_child(b);
	
func frozen(_delta):
	$AnimatedSprite.modulate = Color(0, 0.6, 1, 1);
	freeze_time -= _delta
	if freeze_time <= 0:
		$AnimatedSprite.play("running")
		$AnimatedSprite.modulate = Color(1, 1, 1, 1);
		state = MOVING
		freeze_time = 0
	return

func movement_input() -> Vector2:
	if Input.is_action_just_pressed("space") && dash.c_cooldown == 0:
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
	elif Input.is_action_just_pressed("key_f"):
		projectile_queue = ATTACK_SLOT.C
		state = ATTACKING
	elif Input.is_action_just_pressed("key_r"):
		projectile_queue = ATTACK_SLOT.D
		state = ATTACKING
		
		
func cooldowns():
	if dash.c_cooldown > 0:
		dash.c_cooldown-=1;
	for c in projectiles.values():
		if c.c_cooldown > 0:
			c.c_cooldown-=1;
	
	
func add_spell_arsenal(_projectile_path: String, _slot: int):
	var temp = load(_projectile_path).instance();
	var cooldown = temp.cooldown;
	temp.queue_free();
	projectiles[_slot] = {
		"projectile": load(_projectile_path),
		"cooldown": cooldown,
		"c_cooldown": 0
	}


func health():
	$Camera/ProgressBar.value = current_health/max_health * 100;
func death():
	if current_health <= 0:
		spawn_death()
		emit_signal("PlayerDeath");

func freeze(time: float):
	$AnimatedSprite.stop()
	freeze_time = time
	state = FROZEN
	
	
func set_health(value):
	.set_health(value);
	$AnimatedSprite.modulate = Color(2, 0, 0)
	$Tween.interpolate_callback(self, 0.1, "remove_whiteness")
	$Tween.start();
	
func remove_whiteness():
	$AnimatedSprite.modulate = Color(1, 1, 1);


