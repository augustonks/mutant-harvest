extends Node2D

var current_area: Node2D

@onready var dialog_manager := $CanvasLayer/DialogManager
@onready var player: Player = $Player
@onready var fade = $CanvasLayer/Fade
@onready var ui = $CanvasLayer/UI

signal fade_in
signal fade_out


func _ready():
	randomize()
	player.health_component.hurt.connect(ui.hp_display.update_hp)
	configure_scene()

# Gerencia a transição de áreas.
func change_scene(next_scene_path: String, type: String):
	player.speed = 0
	transition_fade()
	await fade_in
	if player.tilemap:
		player.tilemap = null
	
	# Remove Área atual
	current_area.queue_free()
	
	# Adiciona nova área com base no parâmetro "next_scene_path"
	var pre_scene = load(next_scene_path)
	var next_scene = pre_scene.instantiate()
	await get_tree().create_timer(.25).timeout
	call_deferred("add_child", next_scene) # Gambiarra aqui
	await get_tree().create_timer(.25).timeout
	
	# A cena da área precisa ser o primeiro item da árvore de nodes.
	move_child(next_scene, 0)

	# transportar player na entrada correta
	for i in get_tree().get_nodes_in_group("transition_point"):
			if i.type == type:
				player.global_position = i.player_position

	configure_scene()
	
	await fade_out
	player.speed = 100


func configure_scene():
	current_area = get_child(0)
	if current_area is AreaManager:
		set_player_camera_limit(current_area.current_room)
		current_area.game_manager = self
		current_area.player = player
		player.tilemap = current_area.tilemap

	else:

		if "tilemap" in current_area:
			player.tilemap = current_area.tilemap
			
		set_player_camera_limit(current_area)
	if !dialog_manager.event.is_connected(current_area.game_events):
		dialog_manager.event.connect(current_area.game_events)

	connect_transition_points()
	connect_dialog_points()

func send_dialog(dialog):
	dialog_manager.set_dialog(dialog)


func connect_transition_points():
	for i in get_tree().get_nodes_in_group("transition_point"):
		if !i.is_connected("area_transition", change_scene):
			i.connect("area_transition", change_scene)


func connect_dialog_points():
	for i in get_tree().get_nodes_in_group("interaction_area"):
		if !i.is_connected("send_dialog", send_dialog):
			i.connect("send_dialog", send_dialog)

func set_player_camera_limit(area):
	var camera = player.camera
	camera.limit_top = area.area_limit.top
	camera.limit_bottom = area.area_limit.bottom
	camera.limit_left = area.area_limit.left
	camera.limit_right = area.area_limit.right
	camera.reset_smoothing()

# Fade In e Out para transição de área
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
