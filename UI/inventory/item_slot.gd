class_name ItemSlot
extends Resource

@export
var item: ItemData
@export
var quantity: int = 0

var index: int

func reset():
	item = null
	quantity = 0
