class_name ItemManager
extends Node2D

@export var inventory: InventoryData

var target_tile: Vector2
var tilemap: TilemapManager
var current_item: ItemData
var previous_item: ItemData

#var seed_item = preload("res://UI/inventory/item/seed_redflower.tres")
@onready var player = get_parent()

var temp_tiles: Array

var setting_dir := false
var planting := false

var mouse_pos: Vector2

func _ready():
	previous_item = current_item

func _process(_delta):
	if Input.is_action_just_released("do_action"):
		temp_tiles.clear()
		setting_dir = false
		planting = false
	current_item = inventory.current_item
#	if previous_item != current_item:
#		previous_item = current_item
#		on_item_change()
#	if tilemap:
#		var item = inventory.selected_item
#		if item:
#			if item.type == "plant":
#				tilemap.draw_grid()
#			else:
#				tilemap.erase_grid()
#		else:
#			tilemap.erase_grid()
	

func use_tool(tilemap_r):
	if current_item:
		match current_item.type:
			'tool':
				tilemap_r.set_terrain(current_item.name, target_tile)
			"weapon":
				pass

func do_action(tilemap_r: TilemapManager):
	if tilemap_r and tilemap_r.location == "general":
		var targeted_tile = tilemap_r.get_tile_data()
		if not targeted_tile in temp_tiles:
			temp_tiles.append(targeted_tile)
		
			var item = inventory.selected_item
			
			for crop in tilemap_r.crops:
				if crop.tile_position == targeted_tile.position:
					if crop.is_growth:
						crop.queue_free()
						tilemap_r.crops.erase(crop)
						inventory.add_item(crop.final_crop)
						return
			
			if !planting:
				for plant in tilemap_r.plants:
					if plant.tile_position == targeted_tile.position:
						setting_dir = true
						plant.change_direction()
						return

			if item: 
				if item.type == "seed":
					var planted = tilemap_r.plant_seed(item)
					if planted:
						inventory.remove_item(item)
				if item.type == "tree_seed":
					var _planted = tilemap_r.plant_tree()
				if item.type == "food":
					player.stamina += 10
					inventory.remove_item(item)
				if item.type == "plant" and !setting_dir:
					var price = item.properties.cost
					if Game.sun >= price:
						var planted = tilemap_r.plant_plant(item)
						if planted:
							Game.sun -= price
							planting = true
							
