extends ProgressBar

var hp = 100

func update_hp(new_value, max):
	hp = new_value
	hp = clamp(hp, 0, max)
	max_value = max
	value = hp
