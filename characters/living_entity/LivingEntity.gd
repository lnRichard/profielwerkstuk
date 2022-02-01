extends KinematicBody2D
class_name LivingEntity

# States
enum {IDLING, MOVING, ATTACKING, DASHING, FROZEN, UNLOADED}
var state = IDLING # State the entity is in

# Generic
var max_health: float # Maximum health
var move_speed: float # Move speed of the entity
var current_health: float setget set_health, get_health # Current health
var invulnerable := false # If the entity cannot take damage
var frozen_color := Color(0, 0.6, 1, 1)
var freeze_time := 0.0 # Time the enemy has left being frozen

# Knockback()
var knockback := Vector2.ZERO # Knockback amount
var friction := 200 # Current friction

# death_effect()
var death_effect = preload("res://effects/death_effect/DeathEffect.tscn") # Death effect

# health_indicator()
var indicator := preload("res://indicator/Indicator.tscn")


func _ready():
	if !Global.lighting and is_instance_valid($Light2D):
		$Light2D.queue_free()

# Initialize the entity
func _init(_max_health: float, _move_speed: float):
	max_health = _max_health
	current_health = _max_health
	move_speed = _move_speed

# Physics of the entity
func _physics_process(delta: float):
	knockback(delta)

# Handles entity knockback
func knockback(delta: float):
	if knockback == Vector2.ZERO:
		return

	# Reduce and apply knockback
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	knockback = move_and_slide(knockback)

# Entity-specific override function
func freeze(time: float):
	$AnimatedSprite.stop()
	freeze_time = time
	state = FROZEN

# Entity-specific override function
func attack():
	pass

# Check health
func set_health(value: float):
	if not invulnerable:
		health_indicator(current_health <= 0, current_health - value)
		current_health = value
	else:
		health_indicator(false, 0)

# Returns health
func get_health() -> float:
	return current_health

# Creates a death effect
func death_effect():
	var effect = death_effect.instance()
	effect.global_position = global_position
	get_parent().add_child(effect)
	effect.get_node("DeathEffect").play()

# Creates an health indicator
func health_indicator(killing_blow: bool, health_change: float):
	# Create the label
	var label = indicator.instance()

	# Style the lobal
	label.global_position = global_position

	# Append the label
	if !get_parent():
		return
	get_parent().add_child(label)
	var text = String(health_change)
	if health_change > 0:
		label.get_node("Label").text = text
		label.show_value(killing_blow)
	elif health_change == 0:
		label.get_node("Label").text = text
		label.show_value(killing_blow, Color(1, 1, 1))
	else:
		text.erase(0, 1)
		label.get_node("Label").text = text
		label.show_value(killing_blow, Color(0.12, 0.9, 0.12))

# Creates an all prupose indicator
func indicator(message: String, color: Color, special: bool = false):
	# Create the label
	var label = indicator.instance()

	# Style the lobal
	label.global_position = global_position

	# Append the label
	get_parent().add_child(label)
	label.get_node("Label").text = message
	label.show_value(special, color)
