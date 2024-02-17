extends AreaBase

var cave_manager
var player: Player

var level := 0

var enemies = [
	"res://entities/monster/zombie/zombie.tscn"
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
				var pre_monster = load(enemies[0])
				var monster = pre_monster.instantiate()
				add_child(monster)
				monster.global_position = i * 16
				monster.set_data(tilemap, player)
