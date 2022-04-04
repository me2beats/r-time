extends Node


signal request_add_item(idx, data) # data is dict, see items array; both args optional
signal request_add_separator(idx, name)
signal request_remove_item(idx) # remove item visually, not from items array
signal request_set_item_name(idx, name)
signal request_set_item_date(idx, date) # date is deadline when the timer ends, int (unix?)
signal request_set_item_sound(idx, fn)
signal request_run_item_timer(idx)
signal request_stop_item_timer(idx)
signal request_select_time(idx)

signal item_added(idx, data) # data is optional
signal item_removed(idx, item_data)
signal item_name_set(idx, the_name)
signal item_date_set(idx, date)
signal item_sound_set(idx, fn)
signal item_timer_run(idx)
signal item_timer_stopped(idx)
signal time_selected(idx, deadline)

#could be ItemTypes
enum Types{
	ITEM,
	SEPARATOR
}

# items can be normal items or separators, see type of Types
#var items: = [{type = Types.ITEM, name = "hello", time = OS.get_unix_time()+120, sound = preload("res://alarm2.mp3")}]
var items: = []


func _ready():
	
	connect("item_removed", self, "on_item_removed")
	connect("item_added", self, "on_item_added")
	connect("time_selected", self, "on_time_selected")
	connect("item_sound_set", self, "item_sound_set")

	yield(get_tree(), "idle_frame")
	get_parent().move_child(self, get_parent().get_child_count()-1)

func on_item_removed(idx:int, item_data:Dictionary):
	items.remove(idx)

func on_time_selected(idx:int, deadline:int):
	items[idx].time = deadline

func on_item_added(idx, data:Dictionary):
	idx = idx if idx !=-1 else items.size()
	items.insert(idx, data)

#	var item = get_children()[idx]
	
	if "name" in data:
		Game.emit_signal("request_set_item_name", idx, data.name)

	if "date" in data:
		Game.emit_signal("request_set_item_date", data.date)
	
	if "sound" in data and data.sound:
		Game.emit_signal("request_set_item_sound", idx, data.sound)


func item_sound_set(idx:int, fn:String):
	items[idx].sound = fn

#========== utils ==========

const month = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"]

func get_current_unix_with_offset():
	return	Time.get_unix_time_from_system()+Time.get_time_zone_from_system().bias*60

func get_human_datetime(unix_time:int):
	var datetime_dict = Time.get_datetime_dict_from_unix_time(unix_time)
	return "%s.%02d  %02d:%02d" %[month[datetime_dict.month-1], datetime_dict.day, datetime_dict.hour, datetime_dict.minute]
