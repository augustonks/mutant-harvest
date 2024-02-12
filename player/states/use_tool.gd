extends BaseState

@export var idle_state: BaseState

var finished = false
var processing = false

func start():
	if !processing:
		processing = true
		parent.velocity = Vector2.ZERO
		if parent.tilemap:
			parent.item_manager.use_tool(parent.tilemap)
			if parent.stamina > 0:
				parent.stamina -= 3
		await get_tree().create_timer(.2).timeout
		finished = true
		processing = false

func process(_delta):
	if finished:
		finished = false
		return idle_state
