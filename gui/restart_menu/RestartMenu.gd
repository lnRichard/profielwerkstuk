extends Control


# Restart is loaded
func _ready():
	$VBoxContainer/Score.text = "Score: "  + Global.highscore as String

# Player quits the game
func _on_Quit_pressed():
	get_tree().quit()

# Player restarts the game
func _on_Restart_pressed():
	get_tree().change_scene("res://main/Main.tscn")
