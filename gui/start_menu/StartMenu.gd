extends Control


# Player starts the game
func _on_Start_pressed():
	get_tree().change_scene("res://main/Main.tscn")

# Player quits the game
func _on_Quit_pressed():
	get_tree().quit()

# Player goes to options meny
func _on_Options_pressed():
	pass # Replace with function body.

# Player goes to highscore menu
func _on_Highscore_pressed():
	pass # Replace with function body.
