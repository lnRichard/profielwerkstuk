extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Back_pressed():
	get_tree().change_scene("res://gui/start_menu/StartMenu.tscn")


func _on_Lighting_pressed():
	Global.lighting = $VBoxContainer/Lighting/Lighting.pressed


func _on_Vsync_pressed():
	OS.set_use_vsync($VBoxContainer/Vsync/Vsync.pressed)


func _on_Smooth_pressed():
	Global.smoothing = $VBoxContainer/Smooth/Smooth.pressed


func _on_Window_pressed():
	OS.window_fullscreen = $VBoxContainer/Window/Window.pressed
