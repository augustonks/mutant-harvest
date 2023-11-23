extends ZombieBase

func _process(delta):
	if health.hp <= 10:
		if get_node_or_null('MeshInstance2D'):
			$Gear.queue_free()
