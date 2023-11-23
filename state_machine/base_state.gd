extends Node
class_name BaseState

@onready var state_machine = get_parent()
var parent
var playback
var next_state: BaseState

func start():
	pass

func process(delta):
	pass

func input(event: InputEvent):
	pass

func on_enter():
	pass

func on_exit():
	pass