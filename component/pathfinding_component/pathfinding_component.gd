class_name PathFindingComponent
extends Node2D

@export var parent: Node
@export var speed := 40

var target

var astar_grid = AStarGrid2D.new()
var cell_size = Vector2(16, 16)
var tilemap: TileMap

var is_moving := false
var next_point: Vector2

signal next_point_signal

func set_grid(ptilemap, ptarget):
	tilemap = ptilemap
	var grid_size = tilemap.get_used_rect()
	target = ptarget
	
	astar_grid.region = grid_size
	astar_grid.cell_size = cell_size
	astar_grid.offset = cell_size / 2
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.update()
	set_path()

func set_path():
	next_point = Vector2.ZERO
	
	var path = astar_grid.get_id_path(
		tilemap.local_to_map(global_position),
		tilemap.local_to_map(target.global_position))
	
	path.pop_front()

	if path.is_empty():
		parent.velocity = Vector2.ZERO
		return
	
	if path.size() == 0:
		parent.velocity = Vector2.ZERO
		return
	next_point = Vector2(path[0]) * 16 + Vector2(8, 8)
	is_moving = true
	emit_signal("next_point_signal")


func process(delta):
	if next_point != Vector2.ZERO:
		var direction = (next_point - global_position).normalized()
		parent.velocity = direction * speed

		if global_position.distance_to(next_point) < 1:
			global_position = next_point
			is_moving = false
			set_path()
