extends Area2D

# Signals
signal PlayerTouch

# _on_Exit_body_entered()
var active := false # Checks if the portal can be entered


# Initialize portal
func _ready():
	$AnimatedSprite.play("idle")
	$AnimatedSprite.modulate = Color(0.36, 0.36, 0.36)
	$Light2D.energy = 0.0
	self.connect("PlayerTouch", get_parent().get_parent() , "_exit")
	$Tween.interpolate_callback(self, Global.passed_levels * 4, "activate")
	$Tween.start()

# Player enters the portal
func _on_Exit_body_entered(body: Player):
	if active:
		emit_signal("PlayerTouch")
		$AnimatedSprite.play("close")

# Activate the portal
func activate():
	$AnimatedSprite.modulate = Color(1, 1, 1)
	$Light2D.energy = 0.8
	active = true

# Portal close animation has finished
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "close":
		$AnimatedSprite.stop()
		queue_free()
