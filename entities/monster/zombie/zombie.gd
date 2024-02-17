extends CharacterBody2D

@export var move_state: BaseState
@export var knockback_state: BaseState
@export var hurtbox: HurtboxComponent
@export var health_component: HealthComponent
@export var pathfind: PathFindingComponent
@export var state_machine: StateMachine

func _ready():
	hurtbox.hitbox_entered.connect(knockback)

func set_data(tilemap, ptarget):
	pathfind.set_grid(tilemap, ptarget)

	var wall_layer = tilemap.layer.wall
	for tile in tilemap.get_used_cells(wall_layer):
		var tile_data = tilemap.get_cell_tile_data(wall_layer, tile)
		if tile_data:
			pathfind.astar_grid.set_point_solid(tile)
	
	for ore in tilemap.ores:
		pathfind.astar_grid.set_point_solid(ore.tile_position)
		ore.destroyed.connect(func(signal_ore):
			pathfind.astar_grid.set_point_solid(signal_ore.tile_position, false)
			pathfind.set_path())


func _process(delta):
	if health_component.hp <= 0:
		queue_free()


func _physics_process(delta): 
	move_and_slide()


func knockback(hit):
	state_machine.change_state(knockback_state, [hit])
