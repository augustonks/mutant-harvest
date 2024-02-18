extends CharacterBody2D

@export var move_state: BaseState
@export var knockback_state: BaseState
@export var hurtbox: HurtboxComponent
@export var health_component: HealthComponent
@export var pathfind: PathFindingComponent
@export var state_machine: StateMachine

@onready var animated_sprite := $AnimatedSprite2D

var target: Player


func _ready():
	hurtbox.hitbox_entered.connect(knockback)
	pathfind.next_point_signal.connect(set_flip_h)


func set_data(tilemap, ptarget):
	pathfind.set_grid(tilemap, ptarget)
	target = ptarget

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
			animated_sprite.flip_h = true
		elif target.global_position.x < global_position.x:
			animated_sprite.flip_h = false


func knockback(hit):
	state_machine.change_state(knockback_state, [hit])
