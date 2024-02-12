class_name TilemapManager
extends TileMap

var crops: Array[CropManager]
var trees: Array[TreeManager]
var plants: Array
var weed_dirt_tiles: Array[Vector2i]
var watered_dirt_tiles: Array[Vector2i]
var grass_replace: Array[Vector2i]
var infectedgrass_tiles: Array[Vector2i]

var layer = {
	"grass": 0,
	"infected_grass": 1,
	"dirt": 2,
	"weed_dirt": 3,
	"watered_dirt": 4,
	"cliff": 5,
	"grass_replace": 6,
	"exterior_grass": 7
}

var pre_tile_marking = preload("res://world/tileset/tile_marking.tscn")
var tile_marking
var previous_tile
var current_tile

func _ready():
	previous_tile = get_tile_data()
	current_tile = get_tile_data()
	
	# gerar lista de árvores
	for i in get_tree().get_nodes_in_group("tree"):
		trees.append(i)
		i.tile_position = local_to_map(i.global_position)

	#start_minigame()


# minigame pvz
func start_minigame():
	grass_replace = get_used_cells(layer.grass_replace)
	for tile_pos in grass_replace:
		set_cell(layer.grass_replace, tile_pos)
		set_cell(layer.infected_grass, tile_pos)


# Configurar terreno após uso de ferramenta
func set_terrain(item_name: String):
	var tile_properties = get_tile_data()
	var tile_pos = tile_properties.position

	if item_name == "hoe" and tile_properties.layer1: 
		var tile_data = tile_properties.layer1
		if tile_data.get_custom_data("can_weed"):
			weed_dirt_tiles.append(tile_pos)
			set_cells_terrain_connect(layer.weed_dirt, weed_dirt_tiles, 0,1)
			return
			
	if item_name == "water_can" and tile_properties.layer2:
		var tile_data = tile_properties.layer2
		if tile_data.get_custom_data("can_water"):
			watered_dirt_tiles.append(tile_pos)
			set_cells_terrain_connect(layer.watered_dirt, watered_dirt_tiles, 0,2)
			return
			
	for tree in trees:
		if tree.tile_position == tile_pos:
			tree.hit()


# Plantar semente
func plant_seed(rseed):
	var tile_properties = get_tile_data()
	var tile_pos = tile_properties.position
	
	for crop in crops:
		if crop.tile_position == tile_pos:
			return false
	
	if tile_properties.layer2 or tile_properties.layer3:
		var seed_item = load("res://crop/crop_manager.tscn")
		var seed_instance: CropManager = seed_item.instantiate()
		seed_instance.seed = rseed
		get_parent().add_child(seed_instance)
		
		var local_tile_pos = map_to_local(tile_pos)
		
		seed_instance.position = Vector2(local_tile_pos.x, local_tile_pos.y)
		seed_instance.tile_position = tile_pos
		crops.append(seed_instance)
		return true


# Plantar árvore
func plant_tree():
	var tile_properties = get_tile_data()
	var tile_pos = tile_properties.position
	
	for tree in trees:
		if tree.tile_position == tile_pos:
			return false
	
	if (tile_properties.layer0 or tile_properties.layer1 or 
	tile_properties.layer2 or tile_properties.layer3):
		var tree = load("res://tree/tree_manager.tscn")
		var tree_instance = tree.instantiate()
		get_parent().add_child(tree_instance)
		
		var local_tile_pos = map_to_local(tile_pos)
		
		tree_instance.position = Vector2(local_tile_pos.x, local_tile_pos.y)
		tree_instance.tile_position = tile_pos
		trees.append(tree_instance)
		return true


# Plantar plantas do PVZ
func plant_plant(plant):
	var tile_properties = get_tile_data()
	var tile_pos = tile_properties.position
	
	for plantref in plants:
		if plantref.tile_position == tile_pos:
			return false
	if tile_properties.layer0 and !tile_properties.layer1:
		var pre_plant = load("res://plant/{name}/{name}.tscn".format({"name": plant.name}))
		var new_plant = pre_plant.instantiate()
		get_parent().add_child(new_plant)

		var local_tile_pos = map_to_local(tile_pos)
		
		new_plant.position = Vector2(local_tile_pos.x, local_tile_pos.y)
		new_plant.tile_position = tile_pos
		plants.append(new_plant)
		new_plant.connect("died", remove_plant)
		return true
	return false


func remove_plant(plant):
	plants.erase(plant)


func get_tile_data():
	var mouse_pos = get_global_mouse_position()
	var tile_pos = local_to_map(mouse_pos)
	
	var layer0_data: TileData = get_cell_tile_data(layer.grass, tile_pos)
	var layer1_data: TileData = get_cell_tile_data(layer.infected_grass, tile_pos)
	var layer2_data: TileData = get_cell_tile_data(layer.dirt, tile_pos)
	var layer3_data: TileData = get_cell_tile_data(layer.weed_dirt, tile_pos)
	var layer4_data: TileData = get_cell_tile_data(layer.watered_dirt, tile_pos)

	var tile_properties = {
		"layer0": layer0_data,
		"layer1": layer1_data,
		"layer2": layer2_data,
		"layer3": layer3_data,
		"layer4": layer4_data,
		"position": tile_pos
	}

	return tile_properties


func draw_grid():
	current_tile = get_tile_data()
	if previous_tile != current_tile:
		previous_tile = current_tile
		erase_grid()
		spawn_grid()


func spawn_grid():
	var tile_data = get_tile_data()
	var pos = map_to_local(tile_data.position)
	tile_marking = pre_tile_marking.instantiate()
	add_child(tile_marking)
	tile_marking.global_position = pos
	if !tile_data.layer0 or tile_data.layer1:
		tile_marking.modulate = Color(1, 0, 0)


func erase_grid():
	previous_tile = null
	if is_instance_valid(tile_marking):
		tile_marking.destroy()
