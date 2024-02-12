class_name DialogManager
extends PanelContainer

var dialog_list: Array[String]
var running := false
var line_complete := false
var has_option := false
var index := -1

var response := {
	"yes" = false,
	"no" = false
}
var response_index := 0

var letter_speed := {
	"!" = .35,
	"?" = .35,
	"," = .25,
	"." = .35
}

@onready
var rich_text = $HBoxContainer/RichTextLabel
@onready
var options_list = $HBoxContainer/OptionList
@onready
var type_timer = $TypeTimer
@onready
var yes_button = $HBoxContainer/OptionList/Yes
@onready
var no_button = $HBoxContainer/OptionList/No

signal event

func _process(delta):
	if running:
		line_complete = true if rich_text.visible_ratio == 1 else false

func set_dialog(dialog: Array[String]):
	if !running:
		print(dialog)
		dialog_list = dialog.duplicate()
		visible = true
		running = true
		next_page()

func close_dialog():
	index = -1
	visible = false
	running = false
	response.yes = false
	response.no = false
	response_index = 0

func has_next_page():
	if index >= dialog_list.size() -1:
		return false
	else:
		return true

func next_page():
	if !has_next_page():
		close_dialog()
	else:
		has_option = false
		options_list.visible = false
		rich_text.visible_characters = 0
		index += 1
		if response.yes == true:
			while not "[yes]" + str(response_index)  in dialog_list[index]:
				index += 1
				if !has_next_page():
					close_dialog()
					return
		elif response.no == true:
			while not "[no]" + str(response_index)  in dialog_list[index]:
				index += 1
				if !has_next_page():
					close_dialog()
					return
		if "[option]" in dialog_list[index]:
			dialog_list[index] = dialog_list[index].substr(8)
			has_option = true
		if "[yes]" in dialog_list[index]:
			dialog_list[index] = dialog_list[index].substr(6)
		if "[no]" in dialog_list[index]:
			dialog_list[index] = dialog_list[index].substr(5)
		if "[event]" in dialog_list[index]:
			dialog_list[index] = dialog_list[index].substr(7)
			emit_signal("event", dialog_list[index])
			if !has_next_page():
				close_dialog()
			else:
				next_page()
				return
		rich_text.text = dialog_list[index]
		type_timer.start(0.03)

func _input(event):
	if running and event is InputEvent:
		if event.is_action_pressed("use_tool"):
			if !line_complete:
				rich_text.visible_ratio = 1
			else:
				if !has_option:
					next_page()


func _on_type_timer_timeout():
	if rich_text.visible_ratio != 1:
		var current_length = rich_text.visible_characters
		var next_letter = rich_text.text[current_length]
		rich_text.visible_characters += 1
		if next_letter in letter_speed:
			type_timer.start(letter_speed[next_letter])
		else:
			type_timer.start(.03)
	else:
		if has_option:
			options_list.visible = true
			yes_button.grab_focus()


func _on_yes_pressed():
	response_index += 1
	response.yes = true
	next_page()


func _on_no_pressed():
	response_index += 1
	response.no = true
	next_page()
