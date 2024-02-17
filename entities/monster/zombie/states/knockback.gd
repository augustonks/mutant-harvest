extends BaseState

@export var move_state: BaseState

var knockback_force := 256
var knockback: Vector2


func start(params):
	if params[0]:
		var hit_pos = params[0].global_position
		var dir = (parent.global_position - hit_pos).normalized()
		knockback = dir * knockback_force
		parent.velocity = knockback

func process(delta):
	parent.velocity = parent.velocity.move_toward(Vector2.ZERO, 1000 * delta)
	if parent.velocity == Vector2.ZERO:
		return move_state
