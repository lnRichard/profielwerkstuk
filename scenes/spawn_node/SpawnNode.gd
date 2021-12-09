extends Node2D
class_name SpawnNode

export (int) var weight = 10;

onready var parent = get_parent().get_parent()


var held_enemies = []

func _ready():
	fit_weight();
	spawn_enemies()

func set_weight_multiplier(new_weight_multiplier: float):
	weight*=new_weight_multiplier


func fit_weight():
	var amount = parent.enemies.size();
	var rng = RandomNumberGenerator.new();

	for x in 3:
		rng.randomize();
		var index = rng.randi_range(0, amount-1);
		print(index)
		var e = parent.enemies[index].instance()
		e.position = Vector2(position.x + rng.randi_range(-10, 10), position.y + rng.randi_range(-10, 10))
		held_enemies.push_back(
				e
			);
	
		
func spawn_enemies():
	for e in held_enemies:
		add_child(e)
