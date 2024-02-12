extends Node

var money := 0

var time := 0
var day := 0
var sun := 50

signal new_day

func _process(delta):
	time += delta
	if Input.is_action_just_pressed("ui_page_down"):
		next_day()
		time = 0

func next_day():
	day += 1
	emit_signal("new_day")
