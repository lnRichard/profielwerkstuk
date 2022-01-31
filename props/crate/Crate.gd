extends Destroyable
class_name Crate

# _physics_process()
onready var flask = preload("res://props/Flask/Flask.tscn")
onready var player = get_parent().get_parent().player # Player instance
var speed = 1000 # Get the speed


# Initialize the crate
func _init().(10, 10):
	pass

# Allow pushing of crate
func _physics_process(delta):
	# Detect collision
	var collision = move_and_collide(Vector2.ZERO)
	if collision and collision.collider is Player:
		speed = 2000

	# Move box if it has speed
	if speed > 0:
		if !is_instance_valid(player):
			return
		move_and_slide(player.global_position.direction_to(global_position) * (delta * speed))
		speed -= 100

# Unloads the prop
func unload():
	var flask_instance = flask.instance()
	flask_instance.global_position = global_position
	get_parent().add_child(flask_instance)
	.unload()
