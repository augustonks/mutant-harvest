extends BaseState

@export var walk: BaseState
@export var hitbox: HitboxComponent

@onready var eat_interval = $EatInterval
var plant: PlantBase

func start():
	parent.velocity = Vector2.ZERO
	plant = hitbox.get_overlapping_areas()[0]
	eat()

func eat():
	if plant != null:
		plant.take_damage()
		if plant.hp > 0:
			eat_interval.start()
		else:
			state_machine.change_state(walk)


func _on_eat_interval_timeout():
	eat()
