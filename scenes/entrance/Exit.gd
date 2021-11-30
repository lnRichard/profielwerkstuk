extends Area2D

signal PlayerExit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("PlayerExit", get_parent().get_parent(), "_exit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Exit_body_entered(body):
	if(body.name =="Player"):
		emit_signal("PlayerExit")
#
