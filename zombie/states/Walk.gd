extends BaseState

@export var eat_state: BaseState
@export var hitbox: HitboxComponent

var target: Vector2
var hp = 10
@export var speed := 10

var trajectory: PackedVector2Array
var point = 0

func set_initial_position(line: PackedVector2Array):
	trajectory = line
	parent.global_position = trajectory[point]
	point += 1

func process(delta):
	if trajectory:
		var direction = trajectory[point] - parent.global_position
		parent.velocity = direction.normalized() * speed

		if parent.global_position.distance_to(trajectory[point]) < 1 and point != trajectory.size() - 1:
			point += 1
	
	if hitbox.has_overlapping_areas():
		return eat_state
