extends GPUParticles2D

func _ready():
	emitting = true
	await get_tree().create_timer(5).timeout
	queue_free()
