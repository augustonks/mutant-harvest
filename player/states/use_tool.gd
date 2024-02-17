extends BaseState

@export var idle_state: BaseState
@export var attack_state: BaseState

var finished = false
var processing = false

func start(_params):
	var current_item = parent.item_manager.current_item
	
	if current_item: 
		if current_item.type == "tool":
			parent.velocity = Vector2.ZERO
			if parent.tilemap:
				parent.item_manager.use_tool(parent.tilemap)
				if parent.stamina > 0:
					parent.stamina -= 3
			await get_tree().create_timer(.2).timeout

		elif current_item.type == "weapon":
			return attack_state

	return idle_state

