extends Area2D

# States
enum {IDLING, MOVING, ATTACKING, DASHING, FROZEN, UNLOADED}

# Load entities inside the load area
func _on_LoadArea_body_entered(body: HostileEntity):
	body.state = IDLING

# Unload entities outside the load area
func _on_LoadArea_body_exited(body: HostileEntity):
	body.state = UNLOADED
	body.update_redness()
