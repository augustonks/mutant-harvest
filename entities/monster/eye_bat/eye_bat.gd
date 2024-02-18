extends CharacterBody2D

@export var move_state: BaseState
@export var knockback_state: BaseState
@export var state_machine: StateMachine
@export var hurtbox: HurtboxComponent
@export var health_component: HealthComponent

var max_speed := 90.0

func _ready():
	hurtbox.hitbox_entered.connect(knockback)

func set_data(_tilemap, player):
	move_state.target = player

func _process(delta):
	if health_component.hp <= 0:
		queue_free()

func _physics_process(delta):
	move_and_slide()

func knockback(hit):
	state_machine.change_state(knockback_state, [hit])

