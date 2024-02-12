extends CanvasLayer

@onready var inventory_display := $Control/InventoryDisplay
@onready var inventory_hotbar := $Control/InventoryHotbar
@export var player: CharacterBody2D


func _ready():
	inventory_hotbar.visible = true
	inventory_display.connect("update_display", _update_display)
	inventory_hotbar.connect("update_display", _update_display)


func _process(_delta):
	$Control/Time.text = str("%.2f" % Game.time)
	$Control/Money.text = str("%.2f" % Game.money)
	$Control/ProgressBar.value = player.stamina
	$Control/Panel/Sun.text = str(Game.sun)


func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	
	if event.is_action_pressed("open_menu") and just_pressed:
		if get_tree().paused == false:
			get_tree().paused = true
			inventory_display.update()
			inventory_display.visible = true
		else:
			get_tree().paused = false
			inventory_display.visible = false
			

func _update_display():
	inventory_display.update()
	inventory_hotbar.update()
