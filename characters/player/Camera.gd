extends Camera2D

# Limits camera to level bounds
func _ready():
	limit_top = 0
	limit_left = 0
	limit_bottom = 25 * 16
	limit_right = 25 * 16
