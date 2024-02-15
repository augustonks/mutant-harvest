extends TilemapManager

var ores: Array[OreManager] = [] 

var layer = {
	"floor": 0,
	"wall": 1,
	"ore_spawn": 2,
}

signal ladder_added

var ore_manager = preload("res://entities/ore/ore_manager.tscn")

#func _ready():
#	for i in get_tree().get_nodes_in_group("ore"):
#		ores.append(i)
#		i.tile_position = local_to_map(i.global_position)
#		i.connect("destroyed", remove_ore)

func set_ore():
	var map_size = get_used_cells(2)
	for i in map_size:
		var rand = randf()
		if rand > .7:
			var ore_instance = ore_manager.instantiate()
			get_parent().add_child(ore_instance)
			var level = get_parent().level
			ore_instance.setup(level)
			ore_instance.global_position = Vector2(i.x, i.y) * 16 + Vector2(8, 8)
			ore_instance.tile_position = i
			ores.append(ore_instance)
			ore_instance.connect("ladder_added", func():
				emit_signal("ladder_added"))
			ore_instance.connect("destroyed", remove_ore)


func set_terrain(item_name: String, target_tile: Vector2):
	var tile_properties = get_tile_data(target_tile)
	var tile_pos = tile_properties.position
	
	if item_name == "pickaxe":
		for ore in ores:
			if ore and ore.tile_position == tile_pos:
				var quantity_left = ores.size()
				ore.hit(quantity_left)

func remove_ore(ore):
	ores.erase(ore)

func get_tile_data(target_tile = Vector2.ZERO):
	var tile_pos: Vector2i
	if target_tile == Vector2.ZERO:
		var mouse_pos = get_global_mouse_position()
		tile_pos = local_to_map(mouse_pos)
	else:
		tile_pos = local_to_map(target_tile)

	var layer0_data: TileData = get_cell_tile_data(layer.floor, tile_pos)
	var layer1_data: TileData = get_cell_tile_data(layer.wall, tile_pos)
	var layer2_data: TileData = get_cell_tile_data(layer.ore_spawn, tile_pos)

	var tile_properties = {
		"layer0": layer0_data,
		"layer1": layer1_data,
		"layer2": layer2_data,
		"position": tile_pos
	}

	return tile_properties
