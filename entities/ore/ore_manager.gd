class_name OreManager
extends StaticBody2D

var ladder = preload("res://entities/ladder/ladder.tscn")
var particles = preload("res://visual/particle/ore_break.tscn")
var drop_obj = preload("res://entities/droppable/droppable_object.tscn")

var frame_index = 0

var tile_position: Vector2i
var hp: int

var ores = [
	{"rock0": 0,
	 "probability": 0.125, "hp": 1, "drop_amount": 1,
	 "drop": "res://UI/inventory/item/resource_stone.tres"},
	{"rock1": 1,
	 "probability": 0.125, "hp": 2, "drop_amount": 2,
	 "drop": "res://UI/inventory/item/resource_stone.tres"},
	{"rock2": 2,
	 "probability": 0.125, "hp": 1, "drop_amount": 1,
	 "drop": "res://UI/inventory/item/resource_stone.tres"},
	{"rock3": 3,
	 "probability": 0.125, "hp": 1, "drop_amount": 1,
	 "drop": "res://UI/inventory/item/resource_stone.tres"},
	{"copper": 4,
	 "probability": 0.25, "hp": 2, "drop_amount": 3,
	 "drop": "res://UI/inventory/item/mineral_copper.tres"},
	{"iron": 5,
	 "probability": 0.15, "hp": 3, "drop_amount": 3,
	 "drop": "res://UI/inventory/item/mineral_iron.tres"},
	{"gold": 6,
	 "probability": 0.05, "hp": 4,"drop_amount": 3,
	 "drop": "res://UI/inventory/item/mineral_gold.tres"},
	{"augustium": 7,
	 "probability": 0.025, "hp": 5, "drop_amount": 3,
	 "drop": "res://UI/inventory/item/mineral_augustium.tres"},
	{"supercalifragilisticexpialidocious": 8,
	 "probability": 0.025, "hp": 5, "drop_amount": 3,
	 "drop": "res://UI/inventory/item/mineral_supercalifragilistium.tres"},
]

@onready
var sprite = $Sprite2D
@onready
var animation_player = $AnimationPlayer

signal ladder_added
signal destroyed

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
	frame_index = spawnable_ores[0].values()[0]
	sprite.frame = frame_index
	if frame_index == 8:
		sprite.material.set_shader_parameter("enable_shader", true)
	hp = ores[frame_index].hp


func spawn_ladder():
	var ladder_inst = ladder.instantiate()
	get_parent().add_child(ladder_inst)
	ladder_inst.global_position = global_position
	emit_signal("ladder_added")

func drop(quantity: int, item: ItemData):
	var radius = 10
	var angleDelta = 360.0 / quantity

	for i in range(quantity):
		var angle = deg_to_rad(i * angleDelta)

		# Calculate the position of the object using polar coordinates
		var x = radius * cos(angle)
		var y = radius * sin(angle)
		
		var drop_inst = drop_obj.instantiate()
		drop_inst.item = item
		get_parent().add_child(drop_inst)
		drop_inst.position = Vector2(x, y) + global_position

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
		var item = load(ores[frame_index].drop)
		drop(ores[frame_index].drop_amount, item)
		emit_signal("destroyed", self)
		var particle = particles.instantiate()
		get_parent().add_child(particle)
		particle.global_position = global_position
		queue_free()
