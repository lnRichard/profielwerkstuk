extends Position2D

export var length = Vector2(30, 0);
onready var parent = get_parent() as KinematicBody2D;
func _physics_process(delta):
	var mouse_pos = get_local_mouse_position();
	var angle = mouse_pos.angle();
	var pos = length.rotated(angle);
	position = parent.position + pos;
	print(get_global_mouse_position())

