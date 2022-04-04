extends Button

func _init():
	text = ""
	

func _pressed():
	var idx = owner.get_index()
	Game.emit_signal("request_select_time", idx)
