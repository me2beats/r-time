extends Button

func _pressed():
	Game.emit_signal("request_remove_item", owner.get_index())


