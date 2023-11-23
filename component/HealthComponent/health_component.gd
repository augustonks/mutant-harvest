extends Node2D
class_name HealthComponent

@export var hp = 3
signal died(parent)

func damage():
	hp -= 1
	
	if hp == 0:
		emit_signal("died", get_parent())
		get_parent().queue_free()
