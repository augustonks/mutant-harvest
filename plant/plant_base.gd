extends Area2D
class_name PlantBase

@export var hp = 6

var tile_position: Vector2i

signal died(plant: PlantBase)

var direction: Vector2 = Vector2.RIGHT
@export var can_rotate := false
signal new_direction(dir)

func change_direction():
	if can_rotate:
		direction = direction.rotated(PI / 2)
		
		if direction.is_equal_approx(Vector2.RIGHT) or direction.is_equal_approx(Vector2.LEFT):
			emit_signal("new_direction", "side")
		elif direction.is_equal_approx(Vector2.DOWN):
			emit_signal("new_direction", "down")
		elif direction.is_equal_approx(Vector2.UP):
			emit_signal("new_direction", "up")

func take_damage():
	hp -= 1
	if hp <= 0:
		die()

func die():
	emit_signal('died', self)
	queue_free()
