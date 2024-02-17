extends BaseState

@export var pathfind: PathFindingComponent


func process(delta):
	pathfind.process(delta)


func _on_timer_timeout():
	pathfind.set_path()
