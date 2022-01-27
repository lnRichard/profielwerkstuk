extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Score.text = "Score: "  + Global.highscore as String


func _on_Quit_pressed():
	get_tree().quit();


func _on_Restart_pressed():
	get_tree().change_scene("res://main/Main.tscn");
