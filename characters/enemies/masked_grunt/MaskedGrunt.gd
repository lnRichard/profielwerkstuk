extends HostileEntity

# Generic
onready var projectile := preload("res://projectiles/explosion/Explosion.tscn")
onready var parent := get_parent()

# Attack()
var current_cooldown := 0 # Current cooldown of attack
var cooldown: int # Cooldown of the attack


var danger = 0

# _max_health: float, _move_speed: float, _score: int
func _init().(200.0, 100.0, 10, 10):
	pass

# Initializes the grunt
func _ready():
	# Fetches the attack cooldown
	var temp = projectile.instance()
	cooldown = temp.cooldown
	temp.queue_free()

# Called when the player enters the attack radius
func attack():
	print(danger)
	danger+=2
	if danger > 60:
		var explosion = projectile.instance()
		explosion.global_position = global_position
		parent.add_child(explosion)
		set_health(0)

func cooldowns():
	if danger > 0:
		danger-=1	


# Fetch direction to player
func dir_to_player() -> Vector2:
	return position.direction_to(player.position)	
