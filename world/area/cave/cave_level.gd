extends AreaBase

var cave_manager

@onready
var initial_position = $InitialPosition.global_position
@onready

var level := 0

func _ready():
	if tilemap:
		pass
