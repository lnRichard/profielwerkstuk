extends KinematicBody2D
class_name Flask

# on_pickup()
var health_amount = 20 # Amount to heal entity


# Health entity on pikcup
func on_pickup(body: CollisionObject2D):
	body.set_health(body.current_health + health_amount)
	queue_free()

func _on_Pickup_body_entered(body: CollisionObject2D):
	on_pickup(body)
