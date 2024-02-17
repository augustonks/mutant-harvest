class_name InventoryData
extends Resource

@export var slots: Array[ItemSlot]
var current_item: ItemData

var removing_item = false
signal update

func _init():
	call_deferred("_ready")

func _ready():
	for i in slots.size():
		if slots[i]:
			slots[i].index = i

func add_item(item: ItemData):
	for i in slots.size():
		if slots[i].item == item and slots[i].quantity < 999:
			slots[i].quantity += 1
			emit_signal("update")
			return true

	for i in slots.size():
		if not slots[i].item:
			slots[i].quantity = 1
			slots[i].item = item
			emit_signal("update")
			return true
	return false

func remove_item(item: ItemData):
	if !removing_item:
		removing_item = true
		for i in slots.size():
			if slots[i]:
				if slots[i].index == item.index:
					slots[i].quantity -= 1
					if slots[i].quantity == 0:
						slots[i] = null
			removing_item = false
