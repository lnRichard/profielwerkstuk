extends Position2D


var count := 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	match count:
		0:
			$Light2D.enabled = true
			$AnimatedSprite.play("open");
		1:
			$AnimatedSprite.play("idle");
		2:
			$AnimatedSprite.play("close");
		3:
			$Light2D.enabled = false
			$AnimatedSprite.hide()
			set_physics_process(false)
func _on_AnimatedSprite_animation_finished():
	count+=1;
