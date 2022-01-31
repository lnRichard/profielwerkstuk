extends HostileEntity
class_name Zombie

# Generic
onready var projectile := preload("res://projectiles/melee/Melee.tscn")
onready var parent := get_parent()

# Attack()
var current_cooldown := 0 # Current cooldown of attack
var cooldown: int # Cooldown of the attack


# _max_health: float, _move_speed: float, _score: int
func _init().(10.0, 500.0, 10, 10):
	pass

# Initializes the grunt
func _ready():
	# Fetches the attack cooldown
	var temp = projectile.instance()
	cooldown = temp.cooldown
	temp.queue_free()

# Called when the player enters the attack radius
func attack():
	if current_cooldown == 0:
		# Reset the cooldown
		current_cooldown = cooldown

		# Instances the projectile
		var to_player: Vector2 = dir_to_player()
		var b = projectile.instance()
		b.direction =  10 * to_player #Vector2(10, 0).rotated((player.position).angle()).normalized()

		# Fetch the animated sprite
		var asprite = b.get_node("AnimatedSprite")
		asprite.rotation = position.angle_to_point(to_player)
		asprite.flip_h = to_player.x < 0
		b.position = position + 20 * to_player

		# Append the child
		parent.add_child(b)

# Reduces the cooldown
func cooldowns():
	if current_cooldown > 0:
		current_cooldown -= 1

# Fetch direction to player
func dir_to_player() -> Vector2:
	return position.direction_to(player.position)	
