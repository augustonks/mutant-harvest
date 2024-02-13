class_name InteractionArea
extends Area2D

var interaction_manager

@export var dialog: Array[String]

signal send_dialog


func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("do_action"):
			emit_signal("send_dialog", dialog)


func _on_mouse_entered():
	InteractionManager.register_area(self)


func _on_mouse_exited():
	InteractionManager.unregister_area()
