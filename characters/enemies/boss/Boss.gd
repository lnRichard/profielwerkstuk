class_name BossCreator

var enemy
var sprite: AnimatedSprite
var body: CollisionShape2D
var sight: CollisionShape2D
var attack: CollisionShape2D


func create_boss(boss, factor: int):
	enemy = boss
	print(boss)
	sprite = enemy.get_node("AnimatedSprite")
	body = enemy.get_node("BodyCollision")
	sight = enemy.get_node("Sight/Radius")
	attack = enemy.get_node("Attack/Radius")
	increase_hitbox_and_size(factor)
#	increase_health(factor)
	return enemy
	
func increase_hitbox_and_size(factor: int):
	sprite.scale *= factor
	body.scale *= factor
	sight.scale *= factor 
	attack.scale *= factor

func increase_health(factor: int):
	enemy.max_health *= factor
	enemy.current_health = enemy.max_health
	
