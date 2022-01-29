extends Area2D


enum {IDLING, MOVING, ATTACKING, DASHING, FROZEN, UNLOADED}


func _on_LoadArea_body_entered(body):
	body.state = IDLING

func _on_LoadArea_body_exited(body):
	body.state = UNLOADED
	body.set_health(body.current_health);
