extends KinematicBody2D
class_name Prop

# Creates a death effect
func death_effect():
	var death = preload("res://characters/living_entity/death/DeathEffect.tscn").instance()
	death.global_position = global_position
	get_parent().add_child(death)
	death.get_node("DeathEffect").play()
