extends Area2D

signal PlayerExit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("PlayerExit", get_parent().get_parent(), "_exit")
	print("ready")
	emit_signal("PlayerExit");


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Exit_body_entered(body):
	emit_signal("PlayerExit")
