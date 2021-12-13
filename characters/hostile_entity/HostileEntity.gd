extends LivingEntity
class_name HostileEntity


var player;


func _init().(20):
	pass

func _ready():
	pass


func move():
	pass


# Only detects player
func _on_Sight_body_entered(body):
	player = body;
	state = MOVING;

# Only detects player
func _on_Sight_body_exited(body):
	player = null;
	state = IDLING;
