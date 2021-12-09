extends KinematicBody2D
class_name Player

enum {IDLE, WALKING, DASHING, ATTACKING}
export var speed := 3; # walk speed

export var max_hp := 100.0;
export var hp := 100.0;




var state = IDLE;

var last_direction = Vector2();
export var dash_speed := 15
export var dash_cooldown :=30;
export var dash_current_cooldown := 30; # 30 frames;
export var dash_range := 10 # 30 frames;
export var dash_duration := 0; # duration of ongoing dash

enum Spell {R, L, F, G, NONE}

# Max of FOUR
var eq_spells = [
	preload("res://scenes/spells/fireball/Fireball.tscn"),
	preload("res://scenes/spells/flash_red/flash_red.tscn"),
	preload("res://scenes/spells/iceshard/iceshard.tscn"),
	preload("res://scenes/spells/freeze/freeze.tscn")
	]

var eq_cooldown = [0, 0, 0, 0]

onready var room = get_parent();

func _ready():
	pass


func _process(delta):
	pass


func _physics_process(delta):
	if hp < 1:
		queue_free()
	var velocity = Vector2();
	print(hp)
	# PROTOTYPE FOR CASTING SPELLS
	# IDEA IS TO ADD VARIABLES WHICH ARE THE PATHS TO THE FIREBALLS WHICH WILL BE INSTANTIATED
	# COOL DOWN CAN BE CHECKED 
	
	var spell = spell_ability();
	state = ATTACKING if spell != Spell.NONE else state;

	# make don't go below zero
	# godot passes by value and not reference for these things
	eq_cooldown[0] = eq_cooldown[0]-1 if eq_cooldown[0] > 0 else 0;
	eq_cooldown[1] = eq_cooldown[1]-1 if eq_cooldown[1] > 0 else 0;
	eq_cooldown[2] = eq_cooldown[2]-1 if eq_cooldown[2] > 0 else 0;
	eq_cooldown[3] = eq_cooldown[3]-1 if eq_cooldown[3] > 0 else 0;
	 
	
	dash_current_cooldown = dash_current_cooldown-1 if dash_current_cooldown > 0 else 0
#	print(eq_cooldown)
	if Input.is_action_just_pressed("ui_accept") && dash_current_cooldown <= 0:
		dash_current_cooldown = dash_cooldown # reset;
		state = DASHING;
	match state:
		IDLE:
			$AnimatedSprite.play("default")
			velocity = input();
			if (velocity.length() > 0):
				state = WALKING;
		WALKING:
			$AnimatedSprite.play("running")
			velocity = input();
			if (velocity.length() == 0):
				state = IDLE;
			else:
				last_direction = velocity; # for dash
				move_and_collide(velocity * speed)
				$AnimatedSprite.flip_h = velocity.x < 0;
		DASHING:
			move_and_collide(last_direction * dash_speed);
			dash_duration+=1;
			if dash_duration >= dash_range:
				state = IDLE;
				dash_duration = 0;
		ATTACKING:
			if (eq_cooldown[spell] > 0):
				pass
			else: 
				var instance = eq_spells[spell].instance();
				eq_cooldown[spell] = instance.cooldown;
				instance.direction = Vector2(10, 0).rotated(get_local_mouse_position().angle())
				instance.position = position;
				instance.originPlayer = true;
				instance.get_node("AnimatedSprite").rotation = get_local_mouse_position().angle()
				room.add_child(instance); # So that it's not relative to the player
			state = IDLE

func spell_ability() -> int:
	if Input.is_action_just_pressed("right_click"):
		return Spell.R;
	elif Input.is_action_just_pressed("left_click"):
		return Spell.L
	elif Input.is_action_just_pressed("e_button"):
		return Spell.F;
	elif Input.is_action_just_pressed("q_button"):
		return Spell.G
	else:
		return Spell.NONE
		
func input() -> Vector2:
	var velocity = Vector2();
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	return velocity.normalized();
	
	
func equip_spell(index: int, spell: String):
	eq_spells[index] = load(spell);

func apply_damage(value: float):
	hp-=value;
	
