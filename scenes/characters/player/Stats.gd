extends Node

export var speed = 100; # walk speed
export var max_hp = 100.0;
export var hp = 100.0;
export var dash_speed = 250; # dash distance/speed
export var dash_cooldown = 60; # 0.5 second cooldown

# Variables associated with dash ability TODO: Add state machine?
var dashing = false;
var current_dash_cooldown = 0
var v = Vector2();
var count = 10;
var time = 0;

func _ready():
	pass # Replace with function body.
