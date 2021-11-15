extends "res://scenes/characters/enemies/hostile_entity/HostileEntity.gd"


func _ready():
	# Geef al de stats hier aan. TIM
	
	base_sight = 5;
	apply_sight(base_sight);


func _physics_process(delta):
	var vel = global_position.direction_to(player.global_position)
	$AnimatedSprite.flip_h = vel.x < 0;
	move_and_collide(vel)
