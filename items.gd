extends VBoxContainer

# we can have multiple separators




func move_item_to_done(item_idx:int):
	var item:Control = get_child(item_idx)
	var done_control:Control = get_tree().get_nodes_in_group("done")[0]
	var done_control_idx = done_control.get_index()
	move_child(item, done_control_idx+1)

func move_item_before_done(item_idx:int):
	var item:Control = get_child(item_idx)
	var done_control:Control = get_tree().get_nodes_in_group("done")[0]
	var done_control_idx = done_control.get_index()
	move_child(item, done_control_idx)


func add_done_separator():
	var done_separator = preload("res://item/done_separator.tscn").instance()
	add_child(done_separator)
	Game.items.push_back({type = Game.Types.ITEM, name = "Done"})

func _ready():
#	add_done_separator()

	
	Game.connect("request_remove_item", self, "on_request_remove_item")
	Game.connect("request_add_item", self, "on_request_add_item")
#	Game.connect("item_added", self, "on_item_added")

	Game.connect("request_set_item_name", self, "on_request_set_item_name")

	Game.connect("time_selected", self, "on_time_selected")
	Game.connect("request_set_item_sound", self, "on_request_item_sound")
	Game.connect("item_sound_set", self, "on_sound_set")

func on_request_item_sound(idx:int):
	var dialog = Game.get_node("FileDialog")
	dialog.item_idx = idx
	dialog.signal_to_emit_on_confirm = [Game, "item_sound_set"]
	dialog.popup_centered()

func on_sound_set(idx:int, sound_fn:String):
	var item_control = get_child(idx)
	var button:Button = item_control.get_node("Item/Sound")
	button.text = sound_fn.get_file()
	button.hint_tooltip = sound_fn
	
	var audioplayer:AudioStreamPlayer = item_control.get_node("Sound")
	audioplayer.free()
	var new_player: = AudioStreamPlayer.new()
#	new_player.stream = load(sound_fn)
	
	var audio_loader = AudioLoader.new()
	new_player.set_stream(audio_loader.loadfile(sound_fn))
	
	new_player.name = "Sound"
	item_control.add_child(new_player)

func on_time_selected(idx:int, time:int):
	var item_control = get_child(idx)
	item_control.get_node("Item/Date").text = Game.get_human_datetime(time)
	var timer:Timer = item_control.get_node("Timer")
	timer.wait_time = time-Game.get_current_unix_with_offset()
	
	timer.start()
	
	

func on_request_remove_item(idx):
	get_child(idx).queue_free()
	
	Game.emit_signal("item_removed", idx, Game.items[idx])



func on_request_add_item(idx = -1, data = {name = "", time = 0, sound = ""}):
	var child_count = get_child_count()
	var item:Control = preload("res://item/item.tscn").instance()
	add_child(item)
	if idx !=-1:
		move_child(item, idx)
	else:
		if get_tree().get_nodes_in_group("done"):
			move_item_before_done(child_count)

	var idx_in_parent = item.get_index()
	
	Game.emit_signal("item_added", idx_in_parent, data)

# todo
func add_separator(idx = -1, name = ""):
	pass

func on_request_set_item_name(idx:int, item_name):
	var item_control:Control = get_child(idx)
	item_control.get_node("Item/Name").text = item_name
