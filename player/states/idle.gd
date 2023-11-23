extends BaseState

@export var move_state: BaseState
@export var use_tool_state: BaseState

func input(event):

	if Input.is_action_just_pressed("use_tool"):
		return use_tool_state

	if Input.is_action_pressed("right") or Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left"):
		return move_state

	if Input.is_action_pressed("do_action"):
		parent.item_manager.do_action(parent.tilemap)
