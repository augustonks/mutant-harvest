class_name TransitionPoint
extends Area2D

@export_file() var next_scene
@export_enum("A", "B", "C", "D", "E") var type = "A"
signal area_transition

@onready var player_position

func _ready():
	player_position = $PlayerPosition.global_position

func _on_body_entered(_body):
	emit_signal("area_transition", next_scene, type)
