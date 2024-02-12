extends AreaBase

var game_manager
var player
var level := 0

@onready
var current_room = get_child(0)
var rooms := [
	"res://world/area/cave/0.tscn",
	"res://world/area/cave/1.tscn",
	"res://world/area/cave/2.tscn",
	"res://world/area/cave/3.tscn"
]


func go_to_next_level():
	game_manager.transition_fade()
	await game_manager.fade_in
	current_room.queue_free()
	level += 1
	if level == 1:
		var room1 = load(rooms[1])
		var room1_instance = room1.instantiate()
		add_child(room1_instance)
		current_room = room1_instance
	else:
		var number = randi_range(2, 3)
		var room = load(rooms[number])
		var room_instance = room.instantiate()
		add_child(room_instance)
		current_room = room_instance
	player.global_position = current_room.initial_position
	current_room.tilemap.set_ore()

func game_events(event: String):
	match event:
		"enter_cave":
			go_to_next_level()


func _input(event):
	if event.is_action_pressed("ui_page_down"):
		go_to_next_level()
