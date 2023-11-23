extends Node2D

@export var inventory: InventoryData
var tilemap: TilemapManager
var current_item: ItemData
var previous_item: ItemData

var seed = preload("res://UI/inventory/item/seed_redflower.tres")
@onready var player = get_parent()

var temp_tiles: Array

var setting_dir := false
var planting := false

var mouse_pos: Vector2

func _ready():
	current_item = inventory.selected_item
	previous_item = current_item

func _process(delta):
	if Input.is_action_just_released("do_action"):
		temp_tiles.clear()
		setting_dir = false
		planting = false
#	current_item = inventory.selected_item
#	if previous_item != current_item:
#		previous_item = current_item
#		on_item_change()
	if tilemap:
		var item = inventory.selected_item
		if item:
			if item.type == "plant":
				tilemap.draw_grid()
			else:
				tilemap.erase_grid()
		else:
			tilemap.erase_grid()
	

func use_tool(tilemap):
	var item = inventory.selected_item
	if item:
		match item.type:
			'tool':
				tilemap.set_terrain(item.name)

func do_action(tilemap: TilemapManager):
	var targeted_tile = tilemap.get_tile_data()
	if not targeted_tile in temp_tiles:
		temp_tiles.append(targeted_tile)
	
		var item = inventory.selected_item
		
		for crop in tilemap.crops:
			if crop.tile_position == targeted_tile.position:
				if crop.is_growth:
					crop.queue_free()
					tilemap.crops.erase(crop)
					inventory.add_item(crop.final_crop)
					return
		
		if !planting:
			for plant in tilemap.plants:
				if plant.tile_position == targeted_tile.position:
					setting_dir = true
					plant.change_direction()
					return

		if item: 
			if item.type == "seed":
				var planted = tilemap.plant_seed(item)
				if planted:
					inventory.remove_item(item)
			if item.type == "tree_seed":
				var planted = tilemap.plant_tree()
			if item.type == "food":
				player.stamina += 10
				inventory.remove_item(item)
			if item.type == "plant" and !setting_dir:
				var price = item.properties.cost
				if Game.sun >= price:
					var planted = tilemap.plant_plant(item)
					if planted:
						Game.sun -= price
						planting = true
						
