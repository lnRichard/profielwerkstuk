extends KinematicBody2D
class_name Pickup

# Override function
func on_pickup(body: CollisionObject2D):
	pass

# On item pickup
func _on_Pickup_body_entered(body: CollisionObject2D):
	on_pickup(body)
