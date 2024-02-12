extends Node2D

var current_area: Node2D

@onready
var dialog_manager := $UI/DialogManager
@onready
var player = $Player
@onready
var fade = $UI/Fade

signal fade_in
signal fade_out

func _ready():
	current_area = get_child(0)
	if "game_manager" in current_area:
		current_area.game_manager = self
		current_area.player = player
	connect_transition_points()
	connect_dialog_points()
	dialog_manager.connect("event", current_area.game_events)


func connect_transition_points():
	for i in get_tree().get_nodes_in_group("transition_point"):
			i.connect("area_transition", change_scene)

func connect_dialog_points():
	for i in get_tree().get_nodes_in_group("interaction_area"):
			i.connect("send_dialog", send_dialog)

func transition_fade():
	var tween = get_tree().create_tween()
	tween.tween_property(fade, "modulate:a", 1, .5)
	await tween.finished
	emit_signal("fade_in")
	await get_tree().create_timer(.5).timeout
	tween = get_tree().create_tween()
	tween.tween_property(fade, "modulate:a", 0, .5)
	await tween.finished
	emit_signal("fade_out")

func change_scene(next_scene_path: String, type: String):
	player.speed = 0
	transition_fade()
	await fade_in
	current_area.queue_free()
	var pre_scene = load(next_scene_path)
	var next_scene = pre_scene.instantiate()
	call_deferred("add_child", next_scene)
	await get_tree().create_timer(.5).timeout
	move_child(next_scene, 0)
	current_area = next_scene
	for i in get_tree().get_nodes_in_group("transition_point"):
			if i.type == type:
				player.global_position = i.player_position
	connect_transition_points()
	connect_dialog_points()
	if "game_manager" in current_area:
		current_area.game_manager = self
		current_area.player = player
	if current_area is AreaBase:
		dialog_manager.connect("event", current_area.game_events)

	await fade_out
	player.speed = 100


func send_dialog(dialog):
	dialog_manager.set_dialog(dialog)
	print("set dialog")
