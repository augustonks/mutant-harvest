extends BaseState

var target: Player
@export var knockback_state: BaseState

func process(_delta):
	if target:
		var dir = (target.global_position - parent.global_position).normalized()
		parent.velocity = dir * 50
