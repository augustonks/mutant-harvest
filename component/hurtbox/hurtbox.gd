extends Area2D

@export var health: HealthComponent


func _on_area_entered(area):
	if area is HitboxComponent:
		if health:
			health.damage()
		area.queue_free()
