extends Node

# Create Player
onready var player = preload("res://characters/player/Player.tscn").instance();

func _ready():
	add_child(player)
