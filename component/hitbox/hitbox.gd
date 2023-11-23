extends Area2D
class_name HitboxComponent

signal area_collision(area)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	emit_signal("area_collision", area)
