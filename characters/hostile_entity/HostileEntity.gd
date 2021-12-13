extends LivingEntity
class_name HostileEntity


var player;


func _init().(20):
	pass

func _ready():
	pass


func move():
	pass


# Only detects player because of collision layer
func _on_Sight_body_entered(body):
	player = body;
	state = MOVING;

# Only detects player because of collision layer
func _on_Sight_body_exited(body):
	state = IDLING;
	player = null;


func _on_Attack_body_entered(body):
	player = body;
	state=ATTACKING;


func _on_Attack_body_exited(body):
	state = MOVING;
	player = null;
	
