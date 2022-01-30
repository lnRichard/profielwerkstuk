extends KinematicBody2D
class_name Prop

# death_effect()
var death_effect = preload("res://characters/living_entity/death/DeathEffect.tscn") # Death effect


# Creates a death effect
func death_effect():
	var effect = death_effect.instance()
	effect.global_position = global_position
	get_parent().add_child(effect)
	effect.get_node("DeathEffect").play()
