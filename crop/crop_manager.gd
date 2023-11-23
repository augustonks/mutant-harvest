class_name CropManager
extends Node2D

var seed: ItemData
var stages: int
var actual_stage = 0
var is_growth := false

@onready var sprite: Sprite2D = $Sprite2D
var cell_width
var cell_heigth

var tile_position: Vector2i
@export var final_crop: ItemData


func _ready():
	stages = seed.properties.seed_stages
	Game.connect("new_day", grow)
	final_crop = load("res://UI/inventory/item/" + seed.crop.name + ".tres")
	sprite.texture = seed.texture.atlas
	cell_width = sprite.texture.get_width() / stages
	cell_heigth = sprite.texture.get_height()


func _process(delta):
	sprite.region_rect = Rect2(
		actual_stage * cell_width,
		0,
		cell_width,
		cell_heigth)


func grow():
	actual_stage += 1
	if actual_stage >= stages - 1:
		is_growth = true
		Game.disconnect("new_day_signal", grow)
