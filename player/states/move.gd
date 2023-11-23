extends BaseState

@export var idle_state: BaseState
@export var use_tool_state: BaseState

func process(delta):
	var input_dir := Vector2.ZERO
	input_dir = Input.get_vector("left", "right", "up", "down")


	parent.velocity = input_dir * parent.speed

func input(event):
	if Input.is_action_just_pressed("use_tool"):
		return use_tool_state

	if !Input.is_action_pressed("right") and !Input.is_action_pressed("up") and !Input.is_action_pressed("down") and !Input.is_action_pressed("left"):
		parent.velocity = Vector2.ZERO
		return idle_state

	if Input.is_action_pressed("do_action"):
		parent.item_manager.do_action(parent.tilemap)
