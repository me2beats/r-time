extends Button

func _pressed():
	Game.emit_signal("request_set_item_sound", owner.get_index())

	
