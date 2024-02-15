extends Control

@export var inventory: InventoryData
@onready var slots = $CenterContainer/GridContainer.get_children()
@onready var holded_item_texture = $HoldedItem

var holding = {
	"item": null,
	"quantity": 0
}

signal update_display

func _ready():
	var index = 0
	for slot in slots:
		slot.index = index
		index += 1
		slot.connect("pressed", drag_and_drop)
	
	update()

func _process(_delta):
	if holding.item != null:
		holded_item_texture.texture = holding.item.texture
		holded_item_texture.global_position = get_global_mouse_position()
	else:
		holded_item_texture.texture = null

func update():
	for i in range(0, 30):
		slots[i].set_data(inventory.slots[i], false)

func drag_and_drop(slot_occupied: bool, slot_resource: ItemSlot, slot_display):
#	if !holded_item:
#		if occupied:
#			inventory.slots[slot_display.index] = null
#			holded_item = slot_resource
#	else:
#		if !occupied:
#			inventory.items[slot_display.index] = holded_item
#			holded_item = null
#		else:
#			var previous_item = slot_resource
#			inventory.items[slot_display.index] = holded_item
#			holded_item = previous_item
	if !holding.item:
		if slot_occupied:
			holding.item = slot_resource.item
			holding.quantity = slot_resource.quantity
			slot_resource.reset()
	else:
		if !slot_occupied:
			slot_resource.item = holding.item
			slot_resource.quantity = holding.quantity
			holding.item = null
			holding.quantity = 0
		else:
			var previous_holding = holding.duplicate()
			holding.item = slot_resource.item
			holding.quantity = slot_resource.quantity
			slot_resource.item = previous_holding.item
			slot_resource.quantity = previous_holding.quantity
		

	emit_signal("update_display")
