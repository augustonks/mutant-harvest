extends HitboxComponent

var direction: Vector2
var speed = 80

func _physics_process(delta):
	translate(direction * speed * delta)
	if global_position.x > 1200 or global_position.x < 0 or global_position.y > 1000 or global_position.y < 0:
		queue_free()
