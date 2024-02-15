extends Area2D

@export
var inventory: InventoryData

@onready
var sound = $Pop

func _physics_process(delta):
	for i in get_overlapping_areas():
		if i is DroppableObject:
			if i.collectable:
				var direction = (global_position - i.global_position).normalized()
				var distance = global_position.distance_to(i.global_position)
				var force = 1500 / distance 
				i.translate(direction * force * delta)
				if distance < 5:
					var check = inventory.add_item(i.item)
					if check:
						i.queue_free()
						sound.pitch_scale = randf_range(.9, 1.1)
						sound.play()
					
