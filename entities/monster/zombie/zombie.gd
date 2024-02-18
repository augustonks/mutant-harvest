extends PathfindingEnemy

@onready var flip = $AnimationFlip

func _ready():
	hurtbox.hitbox_entered.connect(knockback)
	pathfind.next_point_signal.connect(set_flip_h)


func _process(_delta):
	if health_component.hp <= 0:
		queue_free()


func _physics_process(_delta):
	if velocity != Vector2.ZERO:
		animated_sprite.play("default")
	else:
		animated_sprite.stop()
	move_and_slide()


func set_flip_h():
	if target:
		if target.global_position.x > global_position.x:
			flip.scale.x = -1
		elif target.global_position.x < global_position.x:
			flip.scale.x = 1
