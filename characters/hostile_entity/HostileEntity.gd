extends LivingEntity
class_name HostileEntity

signal EnemyDeath(score)

var score;

var player;

func _physics_process(delta):
	work_em();
func _init(_max_health: float, _move_speed: float, _score: int).(_max_health, _move_speed):
	score = _score;
	

func connect_death():
	print(get_parent().get_parent())
	self.connect("EnemyDeath", get_parent().get_parent(), "_enemy_death")
	if is_connected("EnemyDeath", get_parent().get_parent(), "_enemy_death"):
		print("AOIWDJAOWIDJ")
	
func work_em():
	cooldowns();
	death()
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
	var walk =  sin(OS.get_ticks_msec()/1000);
	var v = Vector2(walk, 0);
	$AnimatedSprite.flip_h = v.x < 0;
	move_and_slide(v*50);
	
# DETECTING PLAYER AND ADJUSTING STATE OF ENEMY	
	
# Only detects player because of collision layer
func _on_Sight_body_entered(body):
	player = body;
	state = MOVING;

# Only detects player because of collision layer
func _on_Sight_body_exited(body):
	state = IDLING;
	player = null;


func _on_Attack_body_entered(body):
	player = body;
	state=ATTACKING;
	$AnimatedSprite.play("idle")


func _on_Attack_body_exited(body):
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

func death():
	if current_health < 0:
		print("score ", score)
		emit_signal("EnemyDeath", score);
		queue_free();
