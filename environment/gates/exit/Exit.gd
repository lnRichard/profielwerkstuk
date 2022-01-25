extends Area2D


signal PlayerTouch;


func _ready():
	$AnimatedSprite.play("idle");
	self.connect("PlayerTouch", get_parent().get_parent() , "_exit")



func _on_Exit_body_entered(body):
	emit_signal("PlayerTouch")
	$AnimatedSprite.play("close")



func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "close":
		$AnimatedSprite.stop();
		
		queue_free();
		
