extends BaseState

@export var idle_state: BaseState

var finished = false
var processing = false

func start():
	if !processing:
		processing = true
		parent.velocity = Vector2.ZERO
		parent.item_manager.use_tool(parent.tilemap)
		await get_tree().create_timer(.2).timeout
		if parent.stamina > 0:
			parent.stamina -= 3
		finished = true
		processing = false

func process(delta):
	if finished:
		finished = false
		return idle_state
