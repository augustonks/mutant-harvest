extends PlantBase

@onready var animated_sprite = $AnimatedSprite2D

func _process(_delta):
	if hp <= 48 and hp > 24:
		animated_sprite.play("1")
	if hp <= 24:
		animated_sprite.play('2')
