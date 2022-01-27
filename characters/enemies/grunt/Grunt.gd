extends HostileEntity

onready var projectile;
onready var parent = get_parent();
var cooldown;
var c_cooldown = 0;

func _init().(200.0, 100.0, 10):
	pass

func _ready():
	projectile = preload("res://projectiles/melee/Melee.tscn");
	var temp = projectile.instance();
	cooldown = temp.cooldown;
	temp.queue_free();

# attack() is called when player enters the attack radius, for this attack 
# it will be a simple melee attack
func attack():
	if c_cooldown == 0:
		c_cooldown = cooldown;
		var origin = origin_proj();
		var b = projectile.instance();
		b.direction =  10* origin #Vector2(10, 0).rotated((player.position).angle()).normalized()
		var asprite = b.get_node("AnimatedSprite")
		asprite.rotation = position.angle_to_point(origin)
		asprite.flip_h = origin.x < 0;
		b.position = position + 20* origin;
		parent.add_child(b);

func cooldowns():
	if c_cooldown > 0:
		c_cooldown-=1;



func origin_proj() -> Vector2:
	return position.direction_to(player.position);
#	var cur_pos = position;
#	var player_pos = player.position;
#	var direction = cur_pos.direction_to(player_pos)
#	return direction
	
	
