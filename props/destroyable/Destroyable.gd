extends Prop
class_name Destroyable

# Destroy()
var destroyed = false # If the prop is destroyed


# Destroys the prop
func destroy():
	destroyed = true
	$AnimatedSprite.play("destroy")

# Called when animation is finished
func _on_AnimatedSprite_animation_finished():
	if destroyed:
		death_effect()
		queue_free()
