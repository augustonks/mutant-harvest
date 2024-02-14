class_name OreManager
extends StaticBody2D

var ladder = preload("res://entities/ore/ladder.tscn")
var particles = preload("res://visual/particle/ore_break.tscn")

var frame = 0

var tile_position: Vector2i
var hp: int

signal ladder_added
signal destroyed

var ores = [
	{"rock0": 0, "probability": 0.125, "hp": 1},
	{"rock1": 1, "probability": 0.125, "hp": 2},
	{"rock2": 2, "probability": 0.125, "hp": 1},
	{"rock3": 3, "probability": 0.125, "hp": 1},
	{"copper": 4, "probability": 0.25, "hp": 2},
	{"iron": 5, "probability": 0.15, "hp": 3},
	{"gold": 6, "probability": 0.05, "hp": 4},
	{"augustium": 7, "probability": 0.025, "hp": 5},
	{"supercalifragilisticexpialidocious": 8, "probability": 0.025, "hp": 5},
]

@onready
var sprite = $Sprite2D
@onready
var animation_player = $AnimationPlayer

func _ready():
	var rand = randf()
	if rand > .5:
		sprite.flip_h = true

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
	var index = spawnable_ores[0].values()[0]
	sprite.frame = index
	if index == 8:
		sprite.material.set_shader_parameter("enable_shader", true)
	hp = ores[index].hp


func spawn_ladder():
	var ladder_inst = ladder.instantiate()
	get_parent().add_child(ladder_inst)
	ladder_inst.global_position = global_position
	emit_signal("ladder_added")


func hit(quantity_left: int):
	hp -= 1
	animation_player.play("hit")
	if hp <= 0:
		if quantity_left > 1:
			var rand_number = randf()
			if rand_number < .064:
				spawn_ladder()
		else:
			spawn_ladder()
		emit_signal("destroyed", self)
		var particle = particles.instantiate()
		get_parent().add_child(particle)
		particle.global_position = global_position
		queue_free()
