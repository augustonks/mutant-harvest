extends Area2D
class_name HitboxComponent

@export var damage := 1

@onready var collision_box = get_node_or_null("CollisionShape2D")

signal area_collision


func _on_area_entered(area):
	emit_signal("area_collision", area)
