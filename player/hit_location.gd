class_name HitLocation
extends Node2D

@export
var player : Player
@export
var item_manager: ItemManager
@export
var hit_radious: int = 2

@onready
var sprite = $Sprite2D


func _process(delta):
	var mouse_pos := get_global_mouse_position()
	var player_pos = player.global_position
	var distance := Vector2(
		mouse_pos.x - player_pos.x,
		mouse_pos.y - player_pos.y)
	distance.x = clampf(distance.x, -hit_radious * 16, hit_radious * 16)
	distance.y = clampf(distance.y, -hit_radious * 16, hit_radious * 16)
	var target_tile = round((player.global_position + distance - Vector2(8, 8)) / 16) * 16
	sprite.global_position = target_tile + Vector2(8, 8)
	item_manager.target_tile = target_tile

