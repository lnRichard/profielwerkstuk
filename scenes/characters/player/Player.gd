extends KinematicBody2D

export var speed = 100;




# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play("running")
		if velocity.x < 0:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
			
	else:
		$AnimatedSprite.play("default")
	move_and_collide(velocity * delta)
