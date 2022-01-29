extends Area2D


signal PlayerTouch;

var active = false;
func _ready():
	$AnimatedSprite.play("idle");
	$AnimatedSprite.modulate = Color(0.36, 0.36, 0.36)
	$Light2D.energy = 0.0
	self.connect("PlayerTouch", get_parent().get_parent() , "_exit")
	$Tween.interpolate_callback(self, 10.0, "avai")
	$Tween.start()

func _on_Exit_body_entered(body):
	if active:
		emit_signal("PlayerTouch")
		$AnimatedSprite.play("close")


func avai():
	$AnimatedSprite.modulate = Color(1, 1, 1);
	$Light2D.energy = 0.8
	active = true;
	
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "close":
		$AnimatedSprite.stop();
		
		queue_free();
		
