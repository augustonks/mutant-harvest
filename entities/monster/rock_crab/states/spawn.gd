extends BaseState

@export var animated_sprite: AnimatedSprite2D
@export var move_state: BaseState
@export var player_detector: Area2D

func start(params):
	print('tsart')
	parent.velocity = Vector2.ZERO
	if animated_sprite.animation == "move":
		animated_sprite.play("spawn", -1.0, true)

func spawn():
	if running:
		animated_sprite.play("spawn")
	

func _on_animated_sprite_2d_animation_finished():
	if (animated_sprite.animation == "spawn" 
	and animated_sprite.frame != 0):
		state_machine.change_state(move_state)
