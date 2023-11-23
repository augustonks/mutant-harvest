extends Control

@onready var inventory: InventoryData = preload("res://UI/inventory/player_inventory/player_inventory.tres")
@onready var slots := $CenterContainer/GridContainer.get_children()

var selection_index := 0
var selected_item: ItemData
var index_start := 0

signal update_display

func _ready():
	update()

func update():
	for i in range(index_start, index_start + 10):
		var selection_check = false
		if i == selection_index:
			selection_check = true
			inventory.selected_item = inventory.items[i]
		slots[i - index_start].set_data(inventory.items[i], selection_check)

func _process(delta):
	if Input.is_action_just_pressed("ui_home"):
		if visible == true:
			visible = false
		else:
			visible = true

func _input(event):
		var just_pressed = event.is_pressed() and not event.is_echo()
		
		if event.is_action_pressed("tab") and just_pressed:
			index_start += 10
			selection_index += 10
			if index_start > 20:
				index_start = 0
				selection_index -= 30
		if event.is_action_released("scroll_down"):
			selection_index += 1
		if event.is_action_released("scroll_up"):
			selection_index -= 1
		selection_index = clamp(selection_index, index_start, index_start + 9)
		emit_signal("update_display")
