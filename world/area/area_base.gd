class_name AreaBase
extends Node2D

@export var tilemap: TilemapManager
@export var area_limit: Dictionary = {
	"top": -10000,
	"bottom": 10000,
	"left": -10000,
	"right": 10000
}

func game_events(event: String):
	pass
