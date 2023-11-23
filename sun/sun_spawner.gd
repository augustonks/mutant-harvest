extends Node2D

@export var player: CharacterBody2D
@export var sun_interval := 16

@onready var timer = $Timer
var pre_sun = preload("res://sun/sun.tscn")

func _on_timer_timeout():
	timer.wait_time = sun_interval
	var sun = pre_sun.instantiate()
	sun.spawn_point = Vector2(player.global_position.x, player.global_position.y - 112)
	add_child(sun)
	timer.start()
