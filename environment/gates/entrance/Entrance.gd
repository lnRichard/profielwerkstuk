extends Position2D

# _phyics_process()
var count := -1 # Counter value increases after each animation


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Open the portal
func open():
	$AnimatedSprite.play("open")
	count = 0

# Animation has finished
func _on_AnimatedSprite_animation_finished():
	if count != -1:
		count += 1
		match count:
			0:
				$Light2D.enabled = true
				$AnimatedSprite.play("open")
			1:
				$AnimatedSprite.play("idle")
			2:
				$AnimatedSprite.play("close")
			3:
				$Light2D.enabled = false
				$AnimatedSprite.hide()
				set_physics_process(false)
