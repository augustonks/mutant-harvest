extends Node2D

@onready var line = $Line2D

var cell_size = Vector2i(16, 16)
var grid_size
var astar_grid = AStarGrid2D.new()

var start: Vector2i
@export var end: Vector2i


var zombies: Array
var spawned_zombies := 0
var spawn_points: Array

@export var zombie_event: Array= [
	["basic_zombie", 1],
	[0],
	["basic_zombie", 1],
	[0],
	["basic_zombie", 1],
	[0],
	["basic_zombie", 2],
	[0],
	["basic_zombie", 2],
	[0],
	["cone_zombie", 1],
	[0],
	["cone_zombie", 1],
	["basic_zombie", 1],
	[0],
	["cone_zombie", 2],
	["basic_zombie", 2],
	[0],
	["basic_zombie", 2],
	["bucket_zombie", 1],
	[0],
	["bucket_zombie", 2],
	["cone_zombie", 2],
	[0],
	["bucket_zombie", 5],
	["cone_zombie", 4],
	["basic_zombie", 5],
]
var zombie_stage = 0

var grave_texture = preload("res://placeholder/grave.png")

var graves: Array

@export var days: Dictionary = {
	'0': [Vector2(58, 40), Vector2(42, 50), Vector2(19, 42)],
	'1': [Vector2(42, 50), Vector2(19, 42)],
#	'2': [Vector2(58, 40), Vector2(42, 50), Vector2(19, 42)]
}

signal spawned_stage

func _ready():
	randomize()
	initialize_grid()
	set_spawnpoint()
	Game.connect("new_day", set_spawnpoint)

func set_spawnpoint():
	spawn_points.clear()
	for i in graves:
		graves.erase(i)
		i.queue_free()
	for point in days[str(Game.day)]:
		spawn_points.append(point)
		var sprite = Sprite2D.new()
		sprite.texture = grave_texture
		add_child(sprite)
		sprite.global_position = point * 16
		graves.append(sprite)
	update_line()
	
	var sprite = Sprite2D.new()
	sprite.texture = grave_texture
	add_child(sprite)
	sprite.global_position = end * 16
	graves.append(sprite)

func initialize_grid():
	grid_size = Vector2i(74,62)
	astar_grid.size = grid_size
	astar_grid.cell_size = cell_size
	astar_grid.offset = cell_size / 2
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.update()

func update_line():
#	start.x = randf_range(0, 300) / 16
#	start.y = randf_range(0, 170) / 16
	line.points = PackedVector2Array(astar_grid.get_point_path(start, end))

func spawn_zombie(zombie_name: String, quantity: int):
	for i in range(quantity):
		spawn_points.shuffle()
		start = spawn_points[0]
		update_line()
		
		var pre_zombie = load("res://zombie/{name}/{name}.tscn".format({
			"name": zombie_name}))
		
		var zombie = pre_zombie.instantiate()
		zombie.trajectory = line.points
		get_parent().call_deferred("add_child", zombie)
		await zombie.initialized
		zombie.health.connect("died", on_zombie_death)
		zombies.append(zombie)
		spawned_zombies += 1
		await get_tree().create_timer(1.5).timeout
	emit_signal("spawned_stage")
	

func on_zombie_death(zombie):
	zombies.erase(zombie)
	if zombies.is_empty():
		zombies.clear()
		zombie_stage += 1
		next_stage()

func next_stage():
#	if zombie_stage <= zombie_event.size() - 1:
#		spawn_zombie(zombie_event[zombie_stage])
#		print("stagio " + str(zombie_stage))
#		zombie_stage += 1
	if zombie_stage <= zombie_event.size() - 1:
		if typeof(zombie_event[zombie_stage][0]) == TYPE_INT:
			print("AGUARDANDO MORTE DOS ZUMBIS...")
			return
		var zombie_name = zombie_event[zombie_stage][0]
		var quantity = zombie_event[zombie_stage][1]
		spawn_zombie(zombie_name, quantity)
		print(str(quantity) + " ZUMBIS SPAWNADOS, PROSSEGUINDO...")
		await spawned_stage
		zombie_stage += 1
		next_stage()

	else:
		print("ESTAGIO FINALIZADO ")
		zombie_stage = 0

func _on_timer_timeout():
	next_stage()
