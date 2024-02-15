class_name DroppableObject
extends Area2D

var falling := true
var collectable := false
var item: ItemData

@onready
var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = item.texture
	sprite.scale = Vector2(.1, .1)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2(1, 1), .25)
	await get_tree().create_timer(.06).timeout
	falling = false
	collectable = true

func _physics_process(delta):
	if falling:
		translate(Vector2(0, 120) * delta )
