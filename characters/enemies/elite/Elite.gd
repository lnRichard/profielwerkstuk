extends HostileEntity

# Attacks/Prefix
enum {EXPLOSION, FIREBALL, ICEBALL, LIFESTEALMACHINEGUN, MELEE, SMALLSTAR, ZIPPYZIP} # Attack enum
onready var attack: int = rng.randi_range(EXPLOSION, ZIPPYZIP) # Attack type
var prefix: String # Prefix of the elite

# Tag
var tag: String # Name or tag of the elite

# Suffix
enum {HEALTH, SPEED, SIGHT} # Stat boost enum
onready var stat: int = rng.randi_range(HEALTH, SIGHT) # Stat boost type
var suffix: String # Suffix of the elite

# Dialogue
var attack_dialogue: Array
var sight_enter_dialogue: Array
var slight_leave_dialogue: Array

# Misc
var attack_scene: PackedScene # Scene of the attack
onready var parent := get_parent() # Parent of the entity

# Attack()
var current_cooldown := 0 # Current cooldown of attack
var cooldown: int  # Cooldown of the attack

# _max_health: float, _move_speed: float, _score: int
func _init().(0, 0, 100, 100):
	pass

# Physics process
func _physics_process(delta):
	._physics_process(delta)

# Initializes the Elite
func _ready():
	rng.randomize()
	var tag_array = get_array_tag()
	var prefix_array = get_array_prefix()
	var suffix_array = get_array_suffix()
	
	rng.randomize()
	prefix = prefix_array[rng.randi_range(0, prefix_array.size() - 1)]
	tag = tag_array[rng.randi_range(0, tag_array.size() - 1)]
	suffix = suffix_array[rng.randi_range(0, suffix_array.size() - 1)]
	attack_dialogue = get_array_attack_dialogue()
	sight_enter_dialogue = get_array_sight_enter_dialogue()
	slight_leave_dialogue = get_array_sight_leave_dialogue()


	var elite_name = prefix + " " + tag + " " + suffix
	$EliteName.text = elite_name
	
	get_attack()
	get_stats()
	get_cooldown()

# Reduces the cooldown
func cooldowns():
	if current_cooldown > 0:
		current_cooldown -= 1

# Called when the player enters the attack radius
func attack():
	# Idle when player is not seen
	if player_hidden:
		# Check if player is seen again
		if current_cooldown == 60:
			player_hidden = visual_check()
			current_cooldown = 0

		idle()
		return

	if current_cooldown == 0:
		# Reset the cooldown
		current_cooldown = 60
		player_hidden = visual_check()

		# Instances the projectile
		var to_player: Vector2 = dir_to_player()
		var b = attack_scene.instance()
		b.direction =  to_player #Vector2(10, 0).rotated((player.position).angle()).normalized()
		b.position = position + 20 * to_player

		if b is LifestealMachinegun:
			b.caster = self
			b.heal_amount = 5

		# Perform raycast
		var result = space_state.intersect_ray(global_position, b.global_position, [self], 0b00000000000000000001)
		if result:
			# Hit invalid spot
			b.queue_free()
			return

		# Fetch the animated sprite
		var asprite = b.get_node("AnimatedSprite")
		asprite.rotation = position.angle_to_point(to_player)
		asprite.flip_h = to_player.x < 0

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

# Get prefic array
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

# Get dialogue
func get_array_attack_dialogue() -> Array:
	var output = []
	match attack:
		EXPLOSION:
			output.append_array(["BOOM BOOM BOOM!"])
		FIREBALL:
			output.append_array(["FIREBALL"])
		ICEBALL:
			output.append_array(["ELSA MOMENT"])
		LIFESTEALMACHINEGUN:
			output.append_array(["PEW PEW"])
		MELEE:
			output.append_array(["BODY ART"])
		SMALLSTAR:
			output.append_array(["HEAVENLY STAR"])
		ZIPPYZIP:
			output.append_array(["GOTTA SWEEP SWEEP SWEEP"])
	
	match attack:
		HEALTH:
			pass
		SPEED:
			pass
		SIGHT:
			pass

	return output

# Get dialogue
func get_array_sight_enter_dialogue() -> Array:
	var output = []
	match attack:
		EXPLOSION:
			output.append_array(["Hi kid"])
		FIREBALL:
			output.append_array(["Die in a fire"])
		ICEBALL:
			output.append_array(["Let it go"])
		LIFESTEALMACHINEGUN:
			output.append_array(["I will suck your blood"])
		MELEE:
			output.append_array(["Sword art online"])
		SMALLSTAR:
			output.append_array(["HEAVENLY STEPS"])
		ZIPPYZIP:
			output.append_array(["Imagine dragons"])
	
	match attack:
		HEALTH:
			pass
		SPEED:
			pass
		SIGHT:
			pass

	return output

# Get dialogue
func get_array_sight_leave_dialogue() -> Array:
	var output = []
	match attack:
		EXPLOSION:
			output.append_array(["Goodbye kid"])
		FIREBALL:
			output.append_array(["Hey stop running"])
		ICEBALL:
			output.append_array(["I'll freeze you next time"])
		LIFESTEALMACHINEGUN:
			output.append_array(["I will suck your blood, later"])
		MELEE:
			output.append_array(["You die in the game..."])
		SMALLSTAR:
			output.append_array(["HOW?!?"])
		ZIPPYZIP:
			output.append_array(["Zip you"])
	
	match attack:
		HEALTH:
			pass
		SPEED:
			pass
		SIGHT:
			pass

	return output

# Get tag array
func get_array_tag() -> Array:
	return ["Jeremiah", "Ties", "Timo", "Joseph", "Richard", "Angus", "Joromiah", "Rasputin", "Imke", "Tim", "John", "Visser"]

# Get suffix array
func get_array_suffix() -> Array:
	match stat:
		HEALTH:
			return ["of the Ji Clan", "of a thousand years", "the Conqueror", "the Body Cultivator", "the Judge of Death", "the Immortal", "the Impeccable", "Joestar"]
		SPEED:
			return ["of the Li Clan", "of the Clouds", "of the Sky", "of Time", "who Strikes First", "Online"]
		SIGHT:
			return ["of the Wan Clan","of Another World", "who Sees All", "the Mystical", "the Reaper", "of the Nine Heavens"]
	
	return ["Error 1"]

# Get attack
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

# Get cooldown
func get_cooldown():
	var temp: Node = attack_scene.instance()
	cooldown = temp.cooldown
	temp.queue_free()

# Get stats
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

# Set health
func set_health(value: float):
	.set_health(value)
	Global.elite_kills+=1
	Global.skill_points+=1

# TODO: Change to attacking function to stop text spam
#func _on_Attack_body_entered(body: Player):
#	._on_Attack_body_entered(body)
#	indicator(attack_dialogue[rng.randi_range(0, attack_dialogue.size() - 1)], Color(0, 1, 1), false, 0.2)

# Dialogue function
func _on_Sight_body_entered(body: Player):
	._on_Sight_body_entered(body)
	if rng.randi_range(0, 5) == 3:
		indicator(sight_enter_dialogue[rng.randi_range(0, sight_enter_dialogue.size() - 1)], Color(0, 1, 1), false, 0.2)

# Dialogue function
func _on_Sight_body_exited(body: Player):
	._on_Sight_body_exited(body)
	if rng.randi_range(0, 5) == 3:
		indicator(slight_leave_dialogue[rng.randi_range(0, slight_leave_dialogue.size() - 1)], Color(0, 1, 1), false, 0.2)
