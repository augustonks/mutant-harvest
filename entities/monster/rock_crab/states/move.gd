extends BaseState

@export var pathfind: PathFindingComponent
@export var animated_sprite: AnimatedSprite2D

func start(_params):
	animated_sprite.play("move")

func process(delta):
	pathfind.process(delta)


func _on_timer_timeout():
	if running:
		pathfind.set_path()
