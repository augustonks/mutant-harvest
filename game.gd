extends Node2D

var current_area: Node2D

@onready
var dialog_manager := $UI/DialogManager
@onready
var player: Player = $Player
@onready
var fade = $UI/Fade

signal fade_in
signal fade_out


func _ready():
	randomize()
	current_area = get_child(0)
	if "game_manager" in current_area:
		current_area.game_manager = self
		current_area.player = player
	
	# Conecta pontos de transição de áreas e pontos de dialogo para
	# manter monitorar a interação do player com eles
	connect_transition_points()
	connect_dialog_points()
	
	# As vezes, uma linha de diálogo apresentará o termo "[event]".
	# Isso significa que essa linha tem objetivo de emitir um
	# sinal seja para iniciar uma cutscene ou função qualquer
	# no código enquanto o diálogo acontece.
	
	# Tais eventos são listados no "game_events" de cada área:
	dialog_manager.connect("event", current_area.game_events)

	# O player precisa estar ligado ao tilemap de cada área para
	# suas ações que o modifica.
	player.tilemap = current_area.tilemap
	
	set_player_camera_limit(current_area)


func connect_transition_points():
	for i in get_tree().get_nodes_in_group("transition_point"):
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
	print("camera set")

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
	
	# Manter registro da nova área
	current_area = next_scene
	
	# Lista todos os pontos de transição da nova área e
	# teleporta player para o desejado
	for i in get_tree().get_nodes_in_group("transition_point"):
			if i.type == type:
				player.global_position = i.player_position
	
	connect_transition_points()
	connect_dialog_points()
	set_player_camera_limit(current_area)
	
	# Define possíveis variáveis para a nova cena
	if "game_manager" in current_area:
		current_area.game_manager = self
		current_area.player = player
	if current_area is AreaBase:
		dialog_manager.connect("event", current_area.game_events)
	if "tilemap" in current_area:
		player.tilemap = current_area.tilemap
	await fade_out
	player.speed = 100


func send_dialog(dialog):
	dialog_manager.set_dialog(dialog)
