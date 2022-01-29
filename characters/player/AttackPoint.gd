extends Position2D

# _physics_process()
export var length = Vector2(30, 0)
onready var parent = get_parent() as KinematicBody2D

# Updates attack point of follow cursor
func _physics_process(delta):
	var mouse_pos = parent.get_local_mouse_position()
	var angle = mouse_pos.angle()
	var pos = length.rotated(angle)
	position = parent.position + pos
