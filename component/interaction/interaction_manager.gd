extends Node2D

var active_area
var can_interact = true

@onready var label = $Label



func register_area(area: InteractionArea):
	active_area = area

func unregister_area():
	active_area = null

func _process(_delta):
	if label:
		if active_area:
			label.visible = true
			label.global_position = active_area.global_position
			label.global_position.y -= 36
		else:
			label.visible = false
