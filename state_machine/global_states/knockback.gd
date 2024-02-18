extends BaseState

@export var move_state: BaseState
@export var knockback_component: KnockbackComponent

func start(params):
	if params[0]:
		knockback_component.apply_knockback(params[0].global_position)

func process(delta):
	var finished = knockback_component.process(delta)
	if finished:
		return move_state
