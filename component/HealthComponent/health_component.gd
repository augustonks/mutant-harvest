extends Node2D
class_name HealthComponent

@export var max_hp := 100
@export var hp := 100

signal hurt

func damage(hitbox: HitboxComponent):
	hp -= hitbox.damage
	emit_signal("hurt", hp, max_hp)
	
