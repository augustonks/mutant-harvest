extends CharacterBody2D
class_name ZombieBase

@onready var health = $HealthComponent
@onready var walk_state = $StateMachine/Walk
@onready var state_machine = $StateMachine

var trajectory: PackedVector2Array


signal initialized

func _ready():
	walk_state.set_initial_position(trajectory)
	emit_signal("initialized")
	if global_position.x < 616:
		$AnimatedSprite2D.flip_h = true

func _physics_process(delta):
	move_and_slide()

func initialize():
	emit_signal('initialized')
	set_physics_process(true)
