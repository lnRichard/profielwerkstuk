extends Position2D

export var length = Vector2(50, 0);
onready var parent = get_parent() as KinematicBody2D;
func _physics_process(delta):
	var mouse_pos = parent.get_local_mouse_position();
	var angle = mouse_pos.angle();
	var pos = length.rotated(angle);
	position = parent.position + pos;

