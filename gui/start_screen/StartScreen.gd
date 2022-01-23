extends Node2D

onready var start_game_pos = $StartGame.rect_position;
onready var quit_pos = $Quit.rect_position;

onready var start_game_size = $StartGame.rect_size;
onready var quit_size = $Quit.rect_size;

var current_selected = 0;


signal StartGame

func _ready():
	connect("StartGame", get_parent(), "_start_game");
	

func _physics_process(delta):
	current_selected = between_bounds();
	match current_selected:
		0:
			$StartGame.color = Color.gray;
			$Quit.color = Color.gray;
		1:
			$StartGame.color = Color.greenyellow;
			$Quit.color = Color.gray;
		2:
			$Quit.color = Color.greenyellow;
			$StartGame.color = Color.gray
func _input(event):
	if Input.is_action_just_pressed("left_click"):
		match current_selected:
			0:
				pass
			1:
				emit_signal("StartGame")
			2:
				get_tree().quit();


func between_bounds() -> int:
	var mouse_pos = get_global_mouse_position();
	if (mouse_pos.x > start_game_pos.x && mouse_pos.x < start_game_pos.x + start_game_size.x) && (mouse_pos.y > start_game_pos.y && mouse_pos.y < start_game_pos.y + start_game_size.y):
		return 1;
	elif (mouse_pos.x > quit_pos.x && mouse_pos.x < quit_pos.x + quit_size.x) && (mouse_pos.y > quit_pos.y && mouse_pos.y < quit_pos.y + quit_size.y):
		return 2;
	return 0;
