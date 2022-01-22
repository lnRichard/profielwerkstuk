extends HostileEntity

onready var projectile;
onready var parent = get_parent();
var cooldown;
var c_cooldown = 0;

func _init().(200.0, 100.0):
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
		var b = projectile.instance();
		b.direction = Vector2(10, 0).rotated((player.position).angle()).normalized()
		b.get_node("AnimatedSprite").rotation = $AttackPoint.position.angle()
		b.position = $AttackPoint.position;
		print("Projectile Position: ", b.position)
		parent.add_child(b);

func cooldowns():
	if c_cooldown > 0:
		c_cooldown-=1;
