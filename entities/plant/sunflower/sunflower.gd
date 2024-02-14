extends PlantBase

var pre_sun = preload("res://sun/sun.tscn")
@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer

func _ready():
	timer.start()
	timer.wait_time = 20

func sun_load():
	animated_sprite.play("reload")

func _on_timer_timeout():
	sun_load()


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "reload":
		var sun = pre_sun.instantiate()
		sun.falling = false
		sun.global_position = Vector2(global_position.x, global_position.y - 12)
		get_parent().add_child(sun)
		animated_sprite.play("default")
