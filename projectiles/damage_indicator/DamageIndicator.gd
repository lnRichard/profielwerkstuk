extends Node2D

var killing_blow;


var travel = Vector2(0, -80)
var duration = 2
var spread = PI/2
onready var tween = $Tween
onready var label = $Label;

func show_value(killing_blow):
	var movement = Vector2.UP.rotated(rand_range(-spread/2, spread/2)) * 50
	tween.interpolate_property(label, "rect_position",
			label.rect_position, label.rect_position + movement,
			duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(label, "modulate:a",
			1.0, 0.0, duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	if killing_blow:
		modulate = Color(1, 0, 0)
		tween.interpolate_property(label, "rect_scale",
			label.rect_scale*2, label.rect_scale,
			0.4, Tween.TRANS_BACK, Tween.EASE_IN)
			
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()
