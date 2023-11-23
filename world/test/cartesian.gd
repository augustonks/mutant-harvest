extends Node2D

var mouse_pos: Vector2

func _draw():
	draw_line(Vector2(0, mouse_pos.y), Vector2(320, mouse_pos.y), Color.WHITE, 1)
	draw_line(Vector2(mouse_pos.x, 0), Vector2(mouse_pos.x, 180), Color.WHITE, 1)

func _process(delta):
	mouse_pos = get_global_mouse_position()
	queue_redraw()
