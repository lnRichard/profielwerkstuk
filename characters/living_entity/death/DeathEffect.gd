extends AnimatedSprite


func _on_DeathEffect_animation_finished():
	queue_free()
