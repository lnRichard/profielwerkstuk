extends LivingEntity
class_name HostileEntity

var score;

var player;

var freeze_time = 0

var rng = RandomNumberGenerator.new();

func _physics_process(delta):
	work_em(delta);
	._physics_process(delta)


func _init(_max_health: float, _move_speed: float, _score: int).(_max_health, _move_speed):
	score = _score
	
	
func work_em(delta):	
	cooldowns();
	var velocity;
	match state:
		MOVING:
			velocity = move();
		ATTACKING:
#			hek();
			attack()
			velocity = Vector2.ZERO
		IDLING:
			velocity = idle()	
		FROZEN:
			frozen(delta)
			velocity = Vector2.ZERO

	if $SoftCollision.is_colliding():
		velocity += $SoftCollision.get_push_vector() * delta * 400
	move_and_slide(velocity)

#Override this with Astar if smart enemy;
var target = Vector2(0, 0);
var speedAdd = 1
var count = 0;
func move():
	var space_state = get_world_2d().direct_space_state
	if !player:
		return Vector2.ZERO
	var result = space_state.intersect_ray(global_position, player.global_position, [self], collision_mask)
	if result:
		if result is Player:
			state = IDLING
			return Vector2.ZERO
	
	count += 1
	if count == 60:
		target = global_position.direction_to(player.global_position)
		speedAdd = rng.randi_range(0, 30)
		count = rng.randi_range(0, 30)
	$AnimatedSprite.flip_h = target.x < 0;
	$AnimatedSprite.play("running")
	return target * (30 + speedAdd);

#Override this and add attack behaviour
func attack():
	pass

#Override this and add cooldowns
func cooldowns():
	pass

# move between two spots 
var point = global_position
var moving = false
var idle_timeout = 120
func idle(): 
	idle_timeout += 1
	if idle_timeout >= 120:
		idle_timeout = 0
		if rng.randi_range(1, 8) <= 7:
			$AnimatedSprite.play("running")
			point = global_position + Vector2(rng.randi_range(-20, 20), rng.randi_range(-20, 20))
			moving = true
		else:
			$AnimatedSprite.play("idle")
			moving = false

	if moving:
		$AnimatedSprite.play("running")
		var v = global_position.direction_to(point);
		$AnimatedSprite.flip_h = v.x < 0;
# warning-ignore:return_value_discarded
		if global_position.distance_to(point) <= 5:
			idle_timeout = 120
		return v * 50;
	else:
		$AnimatedSprite.play("idle")
	return Vector2.ZERO

func frozen(_delta):
	$AnimatedSprite.modulate = Color(0, 0.6, 1, 1);
	freeze_time -= _delta
	if freeze_time <= 0:
		$AnimatedSprite.play("running")
		state = IDLING
		freeze_time = 0
	return Vector2.ZERO

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
	if state != FROZEN:
		player = body;
		state = ATTACKING;
		$AnimatedSprite.play("idle")


func _on_Attack_body_exited(_body):
	if state != FROZEN:
		state = MOVING;
		$AnimatedSprite.play("running")		


func set_health(value):
	.set_health(value)
	if current_health <= 0:
		spawn_death()
		Global.highscore+=score;
		queue_free();
		return
	var redness
	if current_health <= 0:
		redness = 0.5
	else:
		redness = (max_health * 2) / current_health
		if redness < 0.5:
			redness = 0.5		
	$AnimatedSprite.modulate = Color(redness, 1, 1, 1);

	if max_health <= 0:
		$ProgressBar.value = 0;
	else:
		$ProgressBar.value = current_health/max_health * 100;
func freeze(time: float):
	$AnimatedSprite.stop()
	freeze_time = time
	state = FROZEN

