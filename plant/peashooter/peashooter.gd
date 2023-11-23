extends PlantBase

var projectile = preload("res://plant/projectile/pea_shot.tscn")
@onready var animated_sprite = $AnimatedSprite2D
@onready var raycast = $RayCast2D

func _ready():
	connect("new_direction", set_dir)

func shoot():
	var projectile_inst = projectile.instantiate()
	get_parent().add_child(projectile_inst)
	projectile_inst.global_position = global_position
	projectile_inst.direction = direction

func set_dir(dir: String):
	animated_sprite.play(dir)

func _process(_delta):
	raycast.rotation = direction.angle()
	animated_sprite.flip_h = true if direction.x == -1 else false

func _on_timer_timeout():
	if raycast.is_colliding():
		shoot()
