class_name KnockbackComponent
extends Node2D

@export var parent: Node

var knockback_force := 256
var knockback: Vector2


func apply_knockback(hit_pos: Vector2):
	if hit_pos:
		var dir = (parent.global_position - hit_pos).normalized()
		knockback = dir * knockback_force
		parent.velocity = knockback

func process(delta):
	parent.velocity = parent.velocity.move_toward(Vector2.ZERO, 1000 * delta)
	if parent.velocity == Vector2.ZERO:
		return true
