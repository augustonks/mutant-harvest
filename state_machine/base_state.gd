extends Node
class_name BaseState


var next_state: BaseState
var running := false

var parent
@onready var state_machine: StateMachine = get_parent()

func start(params):
	pass

func process(_delta):
	pass

func input(_event: InputEvent):
	pass

func on_enter():
	pass

func on_exit():
	pass
