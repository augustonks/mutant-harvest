class_name PathFindingComponent
extends Node2D

@export var parent: Node
var target

var astar_grid = AStarGrid2D.new()
var cell_size = Vector2(16, 16)
var tilemap: TileMap

var is_moving := false
var next_point: Vector2

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
	if is_moving:
		return
	next_point = Vector2.ZERO
	parent.velocity = Vector2.ZERO
	
	var path = astar_grid.get_id_path(
		tilemap.local_to_map(global_position),
		tilemap.local_to_map(target.global_position))
	
	path.pop_front()

	if path.is_empty():
		return
	
	if path.size() == 0:
		return
	next_point = Vector2(path[0]) * 16 + Vector2(8, 8)
	is_moving = true


func process(delta):
	if next_point != Vector2.ZERO:
		var direction = (next_point - global_position).normalized()
		parent.velocity = direction * 60

		if global_position.distance_to(next_point) < 1:
			global_position = next_point
			is_moving = false
			set_path()
