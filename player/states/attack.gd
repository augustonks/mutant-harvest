extends BaseState

@export var move_state: BaseState
@export var idle_state: BaseState
@export var hitbox: HitboxComponent

func start(_params):

	parent.velocity = Vector2.ZERO
	var direction = move_state.direction
	
	
	print(direction)

	var angle = calculate_primary_direction(direction)
	angle = fmod(angle, 360)
	hitbox.visible = true
	hitbox.rotation_degrees = angle
	hitbox.collision_box.set_deferred("disabled", false)
	await get_tree().create_timer(.3).timeout
	hitbox.collision_box.set_deferred("disabled", true)
	hitbox.visible = false

	return idle_state

func calculate_primary_direction(direction: Vector2):
	if direction.x == 0:
		return atan2(direction.y, direction.x) * 180 / PI - 90
	elif abs(direction.x) > abs(direction.y):
		return atan2(0, direction.x) * 180 / PI - 90
	else:
		return atan2(0, direction.x) * 180 / PI - 90
