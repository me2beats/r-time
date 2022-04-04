extends Button


func _pressed():
	Game.emit_signal("request_add_item")
