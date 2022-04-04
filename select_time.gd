extends ConfirmationDialog

var minutes = 0
var deadline:int

var current_item:=0

onready var content = $Content

onready var hours_progress =$Content/Control/Hours
onready var minutes_progress = $Content/Control/Minutes

onready var time_left_control = $Content/Control/VBoxContainer/TimeLeft
onready var deadline_control = $Content/Control/VBoxContainer/Deadline


func _ready():
	update_controls()

	Game.connect("request_select_time", self, "on_request_select_time")
	Game.connect("time_selected", self, "on_time_selected")

func get_deadline():
	var time = Game.get_current_unix_with_offset()
	return time+minutes*60

# can be not accurate, test it!
func get_minutes_from_deadline(deadline_unix_time:int):
	var time = Game.get_current_unix_with_offset()
#	return (deadline_unix_time-time+offset*60)/60
	return int(round(deadline_unix_time-time)/60)


func on_request_select_time(idx:int):
	current_item = idx
	var time = Game.items[idx].time
	if not time:
		minutes = 0
	else:
		minutes = get_minutes_from_deadline(time)
	update_controls()
	popup_centered()



var pressed_pos = Vector2.ZERO

signal mouse_released

func _input(event):
	if not visible: return
	
	if event is InputEventMouseButton:
		if event.pressed:
			pressed_pos = event.position-rect_position
			if !content.get_global_rect().has_point(get_global_mouse_position()): return
		else:
			pressed_pos = Vector2.ZERO
			emit_signal("mouse_released")

	if event is InputEventMouseMotion:
		if pressed_pos and event.button_mask:
			if !content.get_global_rect().has_point(get_global_mouse_position()): return
			minutes = max(0, minutes+int(event.relative.x))
			
			deadline = get_deadline()
			update_controls()


const time_left_text = "[center][color=#4fbec1]%s h[/color]  [color=#4f61c1]%s min[/color] [/center]"

# update displayed values
func update_controls():
	hours_progress.value = minutes/60.0/12.0*100.0
#	yield(self, "mouse_released")
	var minutes_to_display = 100 if minutes and !minutes%60 else minutes%60*100.0/60
	minutes_progress.value=minutes_to_display

	time_left_control.bbcode_text =  time_left_text % [minutes/60, minutes%60]
		
	deadline_control.text = Game.get_human_datetime(get_deadline())


func _on_confirmed():
	Game.emit_signal("time_selected", current_item, deadline)


func on_time_selected(idx:int, deadline:int):
	pass
