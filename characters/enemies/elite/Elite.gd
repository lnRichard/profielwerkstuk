extends HostileEntity


enum {EXPLOSION, FIREBALL, ICEBALL, LIFESTEALMACHINEGUN, MELEE, SMALLSTAR, ZIPPYZIP}
onready var attack: int = rng.randi_range(EXPLOSION, ZIPPYZIP)
var prefix: String

var gamer_tag: String

enum {HEALTH, SPEED, SIGHT}
onready var stat: int = rng.randi_range(HEALTH, SIGHT) 
var suffix: String



var attack_scene: PackedScene
onready var parent := get_parent()

# Attack()
var current_cooldown := 0 # Current cooldown of attack
var cooldown: int  # Cooldown of the attack



# _max_health: float, _move_speed: float, _score: int
func _init().(0, 0, 100, 100):
	pass

func _physics_process(delta):
	._physics_process(delta)

func _ready():
	rng.randomize()
	var gamer_tag_array = get_array_gamer_tag()
	var prefix_array = get_array_prefix()
	var suffix_array = get_array_suffix()
	
	rng.randomize()
	prefix = prefix_array[rng.randi_range(0, prefix_array.size() - 1)]
	gamer_tag = gamer_tag_array[rng.randi_range(0, gamer_tag_array.size() - 1)]
	suffix = suffix_array[rng.randi_range(0, suffix_array.size() - 1)]
		
	var elite_name = prefix + " " + gamer_tag + " " + suffix
	$EliteName.text = elite_name
	
	get_attack()
	get_stats()
	get_cooldown()
# Reduces the cooldown
func cooldowns():
	if current_cooldown > 0:
		current_cooldown -= 1


func attack():
	if current_cooldown == 0:
		# Reset the cooldown
		current_cooldown = cooldown * 5

		# Instances the projectile
		var to_player: Vector2 = dir_to_player()
		var b = attack_scene.instance()
		b.direction =  to_player #Vector2(10, 0).rotated((player.position).angle()).normalized()

		# Fetch the animated sprite
		var asprite = b.get_node("AnimatedSprite")
		asprite.rotation = position.angle_to_point(to_player)
		asprite.flip_h = to_player.x < 0
		b.position = position + 20 * to_player

		# Append the child
		parent.add_child(b)
		
		
# Fetch direction to player
func dir_to_player() -> Vector2:
	return position.direction_to(player.position)	

# Handles entity knockback
func knockback(delta: float):
	if knockback == Vector2.ZERO:
		return

	# Reduce and apply knockback
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta * 5)
	knockback = move_and_slide(knockback)

func get_array_prefix() -> Array:
	match attack:
		EXPLOSION:
			return ["Explody", "Erupting", "Banging", "Raging", "Detonating"]
		FIREBALL:
			return ["Fiery", "Warm", "Hot", "Flaming", "Lit", "Scorching", "Burning", "Blazing", "Yang"]
		ICEBALL:
			return ["Jade Beauty", "Yin", "Chilly", "Frozen", "Cold", "Icy", "Snowman", "Snowy"]
		LIFESTEALMACHINEGUN:
			return ["Vampiric", "Heavy", "Machinegun", "Commander"]
		MELEE:
			return ["Overgeared", "Cultivating", "Deadly", "Sharp", "Combative", "Dexterous", "Martial"]
		SMALLSTAR:
			return ["Second Life", "Ancient", "Warlock of the Magus World", "Sovereign","Return of", 
			"Necromancer", "Demon General", "Demon God","Demon Lord", "Reborn", 
			"Once In A Million Years Genius", "Stair Climber", "Great Mage", "9th Circle","Heavenly Demon",
			"Irregular", "Regressed", "Reincarnated" , "S-Rank", "Immortal", "Ancestor", "Heavenly", "Godlike",
			"Supreme", "Demigod", "Deity", "Outer God", "Strongest", "Devil", "Emperor", "I Am", "VRMMO",
			"Invincible", "Almight", "Unrivaled", "Disciple", "Master", "Sect Leader", "Elder", "Inner-Disciple", 
			"Outer-Disciple", "Absolute", "Demoness", "FFF-ranked Hero", "Outcast", "Magic Apprentice", "Monarch" ,
			"Protagonist", "Overlord", "Ranker", "Rotten Water", "Sage Monarch", "Emperor", "Second Coming of"]
		ZIPPYZIP:
			return ["Forceful", "Pushy", "Gravitational", "Assertive", "Dominant"]
	return ["Error 500"]

func get_array_gamer_tag() -> Array:
	return ["Jeremiah", "Ties", "Timo", "Joseph", "Richard", "Angus", "Joromiah", "Rasputin", "Imke", "Tim", "John", "Visser"]

func get_array_suffix() -> Array:
	match stat:
		HEALTH:
			return ["of the Ji Clan", "of a thousand years", "the Conqueror", "the Body Cultivator", "the Judge of Death", "the Immortal", "the Impeccable", "Joestar"]
		SPEED:
			return ["of the Li Clan", "of the Clouds", "of the Sky", "of Time", "who Strikes First", "Online"]
		SIGHT:
			return ["of the Wan Clan","of Another World", "who Sees All", "the Mystical", "the Reaper", "of the Nine Heavens"]
	
	return ["Error 1"]
	
func get_attack():
	match attack:
		EXPLOSION:
			$Sight/Radius.shape.radius = 100
			$Attack/Radius.shape.radius = 30
			attack_scene = preload("res://projectiles/explosion/Explosion.tscn")
		FIREBALL:
			$Sight/Radius.shape.radius = 100
			$Attack/Radius.shape.radius = 90
			attack_scene = preload("res://projectiles/fireball/Fireball.tscn")
		ICEBALL:
			$Sight/Radius.shape.radius = 100
			$Attack/Radius.shape.radius = 90
			attack_scene = preload("res://projectiles/iceball/Iceball.tscn")
		LIFESTEALMACHINEGUN:
			$Sight/Radius.shape.radius = 100
			$Attack/Radius.shape.radius = 90
			attack_scene = preload("res://projectiles/lifesteal_machinegun/LifestealMachinegun.tscn")
		MELEE:
			$Sight/Radius.shape.radius = 100
			$Attack/Radius.shape.radius = 10
			attack_scene = preload("res://projectiles/melee/Melee.tscn")
		SMALLSTAR:
			$Sight/Radius.shape.radius = 100
			$Attack/Radius.shape.radius = 90
			attack_scene = preload("res://projectiles/small_star/SmallStar.tscn")
		ZIPPYZIP:
			$Sight/Radius.shape.radius = 100
			$Attack/Radius.shape.radius = 90
			attack_scene = preload("res://projectiles/zippy_zip/ZippyZip.tscn")

func get_cooldown():
	var temp: Node = attack_scene.instance()
	cooldown = temp.cooldown
	temp.queue_free()

func get_stats():
	match stat:
		HEALTH:
			max_health = 1000
			current_health = 1000
			move_speed = 100
		SPEED:
			max_health = 500
			current_health = 500	
			move_speed = 500
		SIGHT:
			max_health = 500
			current_health = 500
			move_speed = 100
			$Sight/Radius.shape.radius *= 1.5
			$Attack/Radius.shape.radius *= 1.5


func set_health(value: float):
	.set_health(value)
	Global.elite_kills+=1
	Global.skill_points+=1
