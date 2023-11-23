class_name TreeManager
extends StaticBody2D

@export var hp = 5

@onready var animation_player = $AnimationPlayer

var tile_position: Vector2i
var fell = false

func hit():
	if hp <= 1:
		if !fell:
			fell = true
			animation_player.play('fall')
	else:
		animation_player.play("hit")
	hp -= 1


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fall":
		$Top.queue_free()
