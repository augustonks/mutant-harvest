class_name OreManager
extends StaticBody2D

var ladder = preload("res://ore/ladder.tscn")

var frame = 0

var tile_position: Vector2i

signal ladder_added

var ores = [
	{"rock0": 0, "probability": 0.125},
	{"rock1": 1, "probability": 0.125},
	{"rock2": 2, "probability": 0.125},
	{"rock3": 3, "probability": 0.125},
	{"copper": 4, "probability": 0.25},
	{"iron": 5, "probability": 0.15},
	{"gold": 6, "probability": 0.05},
	{"augustium": 7, "probability": 0.025},
	{"supercalifragilisticexpialidocious": 8, "probability": 0.025},
]

@onready
var sprite = $Sprite2D

func setup(level := 1):
	var spawnable_ores = [ores[0], ores[1], ores[2], ores[3]]
	if level >= 5:
		spawnable_ores.append(ores[4])
	if level >= 10:
		spawnable_ores.append(ores[5])
	if level >= 15:
		spawnable_ores.append(ores[6])
	if level >= 20:
		spawnable_ores.append(ores[7])
	if level >= 25:
		spawnable_ores.append(ores[8])
	spawnable_ores.shuffle()
	sprite.frame = spawnable_ores[0].values()[0]
	if sprite.frame == 8:
		sprite.material.set_shader_parameter("enable_shader", true)


func spawn_ladder():
	var ladder_inst = ladder.instantiate()
	get_parent().add_child(ladder_inst)
	ladder_inst.global_position = global_position
	emit_signal("ladder_added")


func destroy(quantity_left: int):
	if quantity_left > 1:
		var rand_number = randf()
		if rand_number < .1:
			spawn_ladder()
	else:
		spawn_ladder()
	queue_free()
