extends CharacterBody2D


var line = Line2D.new()
var tilemap: TilemapManager
var astar_grid = AStarGrid2D.new()
var cell_size = Vector2(16, 16)
var next_point

var is_moving := false

@export var target: Player

func _ready():
	get_parent().add_child(line)
	line.width = 2


func set_data(ptilemap, ptarget):
	tilemap = ptilemap
	target = ptarget
	set_grid()


func _process(_delta):
	if target:
		process_line()

func set_grid():
	var grid_size = tilemap.get_used_rect()
	astar_grid.region = grid_size
	astar_grid.cell_size = cell_size
	astar_grid.offset = cell_size / 2
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.update()
	
	var wall_layer = tilemap.layer.wall
	for tile in tilemap.get_used_cells(wall_layer):
		var tile_data = tilemap.get_cell_tile_data(wall_layer, tile)
		if tile_data:
			astar_grid.set_point_solid(tile)
	
	for ore in tilemap.ores:
		astar_grid.set_point_solid(ore.tile_position)
		ore.destroyed.connect(func(signal_ore):
			astar_grid.set_point_solid(signal_ore.tile_position, false)
			set_path())
	
	set_path()

func set_path():
	if is_moving:
		return
	next_point = Vector2.ZERO
	velocity = Vector2.ZERO
	
	var path = astar_grid.get_id_path(
		tilemap.local_to_map(global_position),
		tilemap.local_to_map(target.global_position))
	
	path.pop_front()

	if path.is_empty():
		return
	
	if path.size() <= 1:
		return
	
	next_point = Vector2(path[0]) * 16
	is_moving = true


func _physics_process(_delta):
	if next_point != Vector2.ZERO:
		var direction = (next_point - global_position).normalized()
		velocity = direction * 20

		if global_position.distance_to(next_point) < 1:
			global_position = next_point
			is_moving = false
			set_path()

		move_and_slide()

func process_line():
	line.points = PackedVector2Array(astar_grid.get_point_path(
		global_position / cell_size, target.global_position / cell_size))


func _on_timer_timeout():
	set_path()
