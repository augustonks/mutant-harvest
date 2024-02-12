extends TileMap

var layer = {
	"floor": 0,
	"wall": 1,
	"ore_spawn": 2,
}

var ore = preload("res://ore/ore.tscn")

func set_ore():
	var map_size = get_used_cells(2)
	for i in map_size:
		var rand = randf()
		if rand > .7:
			var ore_instance = ore.instantiate()
			get_parent().add_child(ore_instance)
			ore_instance.global_position = Vector2(i.x, i.y) * 16 + Vector2(8, 8)
		

func get_tile_data():
	var mouse_pos = get_global_mouse_position()
	var tile_pos = local_to_map(mouse_pos)
	
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
