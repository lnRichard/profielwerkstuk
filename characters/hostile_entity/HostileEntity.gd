extends LivingEntity
class_name HostileEntity

enum TYPE_BONUS { NORMAL, STRENGTH, HEALTH, REGEN }

var type = TYPE_BONUS.NORMAL

var score;

var player;

func _physics_process(_delta):
	work_em();
func _init(_max_health: float, _move_speed: float, _score: int).(_max_health, _move_speed):
	var rng = RandomNumberGenerator.new();
	rng.randomize()
	var result = rng.randi_range(1, 100)
	if result <= 20:
		type = rng.randi_range(1, 3);
	score = _score;
	


	
func work_em():
	cooldowns();
	death()
	health()
	match state:
		MOVING:
			move();
		ATTACKING:
#			hek();
			attack()
		IDLING:
			idle()	
			

#Override this with Astar if smart enemy;
func move():
	var vel = global_position.direction_to(player.global_position)
	$AnimatedSprite.flip_h = vel.x < 0;
	$AnimatedSprite.play("running")
# warning-ignore:return_value_discarded
	move_and_slide(vel * 50)

#Override this and add attack behaviour
func attack():
	pass

#Override this and add cooldowns
func cooldowns():
	pass

# move between two spots 
func idle(): 
	$AnimatedSprite.play("running")
# warning-ignore:integer_division
	var walk =  sin(OS.get_ticks_msec()/1000);
	var v = Vector2(walk, 0);
	$AnimatedSprite.flip_h = v.x < 0;
# warning-ignore:return_value_discarded
	move_and_slide(v*50);
	
# DETECTING PLAYER AND ADJUSTING STATE OF ENEMY	
	
# Only detects player because of collision layer
func _on_Sight_body_entered(body):
	player = body;
	state = MOVING;

# Only detects player because of collision layer
func _on_Sight_body_exited(_body):
	state = IDLING;
	player = null;


func _on_Attack_body_entered(body):
	player = body;
	state=ATTACKING;
	$AnimatedSprite.play("idle")


func _on_Attack_body_exited(_body):
	state = MOVING;
	$AnimatedSprite.play("running")		


# shouldn't need adjusting
# do not override
#export var length = Vector2(5, 0);
#func hek():
#	var ap = $AttackPoint
#	var player_pos = player.position as Vector2;
#	var angle = player_pos.direction_to(position).angle();
#	var pos = length.rotated(angle);
#	ap.position = position + pos;

func health():
	$ProgressBar.value = current_health/max_health * 100;

func death():
	if current_health <= 0:
		Global.highscore+=score;
		queue_free();
