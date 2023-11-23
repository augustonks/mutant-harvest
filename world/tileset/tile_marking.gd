extends Node2D

var zombie: Array
func destroy():
	if !zombie.is_empty():
		for i in zombie:
			if is_instance_valid(i):
				i.modulate = Color(1,1,1)
	queue_free()


func _on_area_2d_area_entered(area):
	area.get_parent().modulate = Color(1,0,0)
	zombie.append(area.get_parent())
	
