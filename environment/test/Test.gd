extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var nav = $Navigation2D
	var path = nav.get_simple_path(Vector2(0, 0), Vector2(32, 32))
	print(path)
