class_name HurtboxComponent
extends Area2D

@export var health: HealthComponent
@export var hitbox: HitboxComponent

signal hitbox_entered

func _on_area_entered(area):
	if area is HitboxComponent and area != hitbox:
		if health:
			health.damage(area)
		emit_signal("hitbox_entered", area)
