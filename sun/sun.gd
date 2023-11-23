extends Area2D

var speed := 50
var spawn_point: Vector2
var stop_point
var collected := false
var falling := true

func _ready():
	if falling:
		global_position = Vector2(
			randf_range(spawn_point.x - 160, spawn_point.x),
			spawn_point.y)
		stop_point = randf_range(spawn_point.y, spawn_point.y + 180)
	else:
		spawn_point = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if falling:
		if not global_position.y >= stop_point and !collected:
			translate(Vector2(1,1) * speed * delta)
	else:
		global_position.lerp(Vector2(spawn_point.x + 16,spawn_point.y + 16), 10 * delta)


func _on_mouse_entered():
	collected = true
	Game.sun += 25
	var tween = get_tree().create_tween()
	
	tween.tween_property(self, "global_position",
	Vector2(global_position.x - 320, global_position.y - 180), .5)
	
	tween.parallel().tween_property(self, "modulate:a", 0, .25)
	await tween.finished
	queue_free()


func _on_destroy_timeout():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, .25)
	await tween.finished
	queue_free()
