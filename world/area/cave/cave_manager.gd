class_name AreaManager
extends Node2D

var tilemap
var game_manager
var player
var level := 0

@onready
var current_room: AreaBase = get_child(0)
var rooms := [
	"res://world/area/cave/0.tscn",
	"res://world/area/cave/1.tscn",
	"res://world/area/cave/2.tscn",
	"res://world/area/cave/3.tscn",
	"res://world/area/cave/4.tscn",
	"res://world/area/cave/5.tscn",
]
func _ready():
	if current_room.tilemap:
		tilemap = current_room.tilemap
	else:
		print("Nível de caverna não possui tilemap")

# Lida com a progressão de níveis na caverna
func go_to_next_level():
	InteractionManager.active_area = null # Temporário
	game_manager.transition_fade()
	
	await game_manager.fade_in
	
	# Remove nível atual
	current_room.queue_free()

	level += 1
	if level == 1: # Nível 1 sempre terá o mesmo design
		var room1 = load(rooms[1])
		var room1_instance = room1.instantiate()
		current_room = room1_instance
	else: # Diferentemente dos outros, que serão aleatórios.
		var number = randi_range(2, rooms.size() - 1)
		var room = load(rooms[number])
		var room_instance = room.instantiate()
		current_room = room_instance

	current_room.cave_manager = self
	current_room.level = level
	current_room.player = player

	add_child(current_room)

	tilemap = current_room.tilemap

	player.global_position = current_room.initial_position
	game_manager.configure_scene()

	# Conecta o ponto de interação de uma escada gerada com
	# o Game Manager, assim, é possível interagir com ela e
	# descer de nível nas cavernas.
	current_room.tilemap.connect("ladder_added", func():
		game_manager.connect_dialog_points())


func game_events(event: String):
	match event:
		"enter_cave":
			go_to_next_level()

# DEBUG
func _input(event):
	if event.is_action_pressed("ui_page_down"):
		go_to_next_level()
