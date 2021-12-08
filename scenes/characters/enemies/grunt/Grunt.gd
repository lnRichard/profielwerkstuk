extends "res://scenes/characters/enemies/hostile_entity/HostileEntity.gd"


func _ready():
	apply_sight()
	apply_multiplier()

func _init().(20, 1, 10, 10, 1, 1):
	pass
func _physics_process(delta):
	
	match state:
		IDLE:
			$AnimatedSprite.play("idle")
		CHASING:
			var vel = global_position.direction_to(player.global_position)
			$AnimatedSprite.flip_h = vel.x < 0;
			$AnimatedSprite.play("running")
			move_and_collide(vel)
		ATTACKING:
			pass
