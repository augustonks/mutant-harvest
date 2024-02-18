extends AreaBase

var cave_manager
var player: Player

var level := 0

var enemies = [
	"res://entities/monster/zombie/zombie.tscn",
	"res://entities/monster/eye_bat/eye_bat.tscn",
	"res://entities/monster/rock_crab/rock_crab.tscn",
]

@onready
var initial_position = $InitialPosition.global_position

func _ready():
	if tilemap:
		tilemap.set_ore()
		if level > 1:
			set_enemies()

func set_enemies():
	var map_size = tilemap.map_size
	for i in map_size:
		var can_spawn := true
		if i in tilemap.entity_tiles:
			can_spawn = false
		if can_spawn:
			var rand = randf()
			if rand < .01:
				var rand_monster = randi_range(0, enemies.size() - 1)
				var pre_monster = load(enemies[rand_monster])
				var monster = pre_monster.instantiate()
				add_child(monster)
				monster.global_position = Vector2(i) * 16 + Vector2(8, 8)
				monster.set_data(tilemap, player)
