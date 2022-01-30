extends Position2D

# _phyics_process()
var count := 0 # Counter value increases after each animation


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Checks what state the protal is in
func _physics_process(delta: float):
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

# Animation has finished
func _on_AnimatedSprite_animation_finished():
	count += 1
