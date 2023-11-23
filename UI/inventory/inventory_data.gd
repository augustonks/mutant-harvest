class_name InventoryData
extends Resource

@export var items: Array[ItemData]
var selected_item: ItemData

var removing_item = false

func _init():
	call_deferred("_ready")

func _ready():
	for i in items.size():
		if items[i]:
			items[i].index = i

func add_item(item: ItemData):
	for i in items.size():
		if items[i] and items[i].name == item.name:
			items[i].quantity += 1
			return

	for i in items.size():
		if not items[i]:
			item.index = i
			item.quantity = 1
			items[i] = item
			return


func remove_item(item: ItemData):
	if !removing_item:
		removing_item = true
		for i in items.size():
			if items[i]:
				if items[i].index == item.index:
					items[i].quantity -= 1
					if items[i].quantity == 0:
						items[i] = null
			removing_item = false
