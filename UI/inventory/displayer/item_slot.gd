extends Panel

@onready var texture_rect := $TextureRect
@onready var quantity_panel := $Panel
@onready var quantity_display := $Panel/QuantityDisplay
@onready var sun_texture := $Panel/SunText

var index: int
var occupied := false
var slot: ItemSlot

signal pressed(occupied, item, slot)

func set_data(r_slot: ItemSlot, selected):
	slot = r_slot
	if r_slot.item:
		texture_rect.visible = true
		texture_rect.texture = slot.item.texture
		occupied = true
		
		if slot.item.type != 'plant':
			sun_texture.visible = false
			if slot.quantity > 1:
				quantity_panel.visible = true
				quantity_display.text = str(slot.quantity)
			else:
				quantity_panel.visible = false
		else:
			quantity_display.text = str(slot.item.properties.cost)
			quantity_panel.visible = true
			sun_texture.visible = true
	else:
		occupied = false
		texture_rect.visible = false
		quantity_panel.visible = false

	if selected:
		modulate = Color(1,1,1)
		texture_rect.scale = Vector2(1, 1)
	else:
		modulate = Color(.6, .6, .6)
		texture_rect.scale = Vector2(1, 1)


func _on_gui_input(event):
	if event is InputEventMouseButton:
		var just_pressed = event.is_pressed() and not event.is_echo()
		if just_pressed:
			emit_signal("pressed", occupied, slot, self)
