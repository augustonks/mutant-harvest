extends Control

@export var inventory: InventoryData
@onready var slots = $CenterContainer/GridContainer.get_children()
@onready var holded_item_texture = $HoldedItem

var holded_item: ItemData
signal update_display

func _ready():
	var index = 0
	for slot in slots:
		slot.index = index
		index += 1
		slot.connect("pressed", drag_and_drop)
	
	update()

func _process(_delta):
	if holded_item:
		holded_item_texture.texture = holded_item.texture
		holded_item_texture.position = get_global_mouse_position()
	else:
		holded_item_texture.texture = null

func update():
	for i in range(0, 30):
		slots[i].set_data(inventory.items[i], false)

func drag_and_drop(occupied, item, slot):
	if !holded_item:
		if occupied:
			inventory.items[slot.index] = null
			holded_item = item
	else:
		if !occupied:
			inventory.items[slot.index] = holded_item
			holded_item = null
		else:
			var previous_item = item
			inventory.items[slot.index] = holded_item
			holded_item = previous_item
	emit_signal("update_display")
