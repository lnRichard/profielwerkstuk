extends Prop
class_name Destroyable

# Destroy()
var destroyed := false # If the prop is destroyed
var score := 0
var xp := 0


# Initialize the destroyable
func _init(_score: int, _xp: int):
	score = _score
	xp = _xp

# Destroys the prop
func destroy():
	destroyed = true
	$AnimatedSprite.play("destroy")

# Unloads the prop
func unload():
	Global.highscore += score
	Global.xp += xp
	death_effect()
	queue_free()

# Called when animation is finished
func _on_AnimatedSprite_animation_finished():
	if destroyed:
		unload()
