extends Node2D

# Onready
onready var tween = $Tween
onready var label = $Label

# show_value()
var travel = Vector2(0, -80) # How far the label travels
var duration = 2 # How long the label travels
var spread = PI/2 # How much the label spreads


# Shows a indicator
func show_value(special: bool, color = null, size = 1):
	# Set size
	var font = label.get_font("font")
	font.size = size * 16
	label.add_font_override("font", font)

	# Change color if color is set
	if color:
		label.add_color_override("font_color", color)

	# How much the indicator should spread
	var movement = Vector2.UP.rotated(rand_range(-spread / 2, spread / 2)) * 50

	# Interpolate the position
	tween.interpolate_property(label, "rect_position",
			label.rect_position, label.rect_position + movement,
			duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	# Interpolate the alpha value
	tween.interpolate_property(label, "modulate:a",
			1.0, 0.0, duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	# If special label
	if special:
		# Interpolate the rectangle scale
		tween.interpolate_property(label, "rect_scale",
			label.rect_scale*2, label.rect_scale,
			0.4, Tween.TRANS_BACK, Tween.EASE_IN)

	# Start tween and end
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()
