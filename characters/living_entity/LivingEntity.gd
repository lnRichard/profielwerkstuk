extends KinematicBody2D
class_name LivingEntity

# States
enum {IDLING, MOVING, ATTACKING, DASHING, FROZEN, UNLOADED}
var state = IDLING # State the entity is in

# Generic
var max_health # Maximum health
var move_speed # Move speed of the entity
var current_health setget set_health, get_health # Current health
var invulnerable = false # If the entity cannot take damage
var frozen_color = Color(0, 0.6, 1, 1)

# Knockback()
var knockback = Vector2.ZERO # Knockback amount
var friction = 200 # Current friction


# Initialize the entity
func _init(_max_health: float, _move_speed: float):
	max_health = _max_health
	current_health = _max_health
	move_speed = _move_speed

# Physics of the entity
func _physics_process(delta):
	knockback(delta)

# Handles entity knockback
func knockback(delta):
	if knockback == Vector2.ZERO:
		return

	# Reduce and apply knockback
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	knockback = move_and_slide(knockback)

# Entity-specific override function
func freeze(time: float):
	pass

# Entity-specific override function
func attack():
	pass

# Check health
func set_health(value: float):
	if not invulnerable:
		current_health = value

# Returns health
func get_health() -> float:
	return current_health

# Creates a death effect
func death_effect():
	var death = preload("res://characters/living_entity/death/DeathEffect.tscn").instance()
	death.global_position = global_position
	get_parent().add_child(death)
	death.get_node("DeathEffect").play()
