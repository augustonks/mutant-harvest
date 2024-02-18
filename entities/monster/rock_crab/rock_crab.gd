extends PathfindingEnemy

@export var idle_state: BaseState
@export var player_detector: Area2D

func _on_player_enter_area_body_entered(body):
	if body is Player:
		idle_state.spawn()

func _process(_delta):
	if move_state.running:
		if player_detector.get_overlapping_bodies().is_empty():
			state_machine.change_state(idle_state)

	if health_component.hp <= 0:
		queue_free()

func _physics_process(_delta):
	move_and_slide()



