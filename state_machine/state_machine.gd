extends Node
class_name StateMachine

var current_state: BaseState
signal initialized

func _ready():
	for i in get_children():
		i.parent = get_parent()
	
	current_state = get_children()[0]

func _physics_process(delta):
	var new_state = current_state.process(delta)
	if new_state:
		change_state(new_state)

func _input(event):
	var new_state = current_state.input(event)
	if new_state:
		change_state(new_state)

func change_state(new_state, params := []):
	current_state = new_state
	var new_state2 = await current_state.start(params)
	if new_state2:
		change_state(new_state2)
