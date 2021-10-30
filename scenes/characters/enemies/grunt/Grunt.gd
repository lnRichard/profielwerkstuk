extends "res://scenes/characters/enemies/EnemyBaseScript.gd"

var player;

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("idle")
	set_physics_process(false);

	speed = 400

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CollisionShape2D_ready():
	sight_radius = 10;
	var node = get_node("Area2D/CollisionShape2D");
	node.scale*=sight_radius

func _physics_process(delta):
	var vel = global_position.direction_to(player.global_position)
	$AnimatedSprite.flip_h = vel.x < 0;
	move_and_collide(vel)


func _on_Area2D_body_entered(body):
	if (body.name == "Player"):
		$AnimatedSprite.play("running")
		set_physics_process(true)
		player = body;


func _on_Area2D_body_exited(body):
	if (body.name == "Player"):
		$AnimatedSprite.play("idle")
		set_physics_process(false)
		player = null;
