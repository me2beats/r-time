extends Control

func _ready():
	Game.connect("item_removed", self, "on_item_removed")

func on_item_removed(idx:int, item_data:Dictionary):
	var scrollcontainer = $"../../../ScrollContainer"
	var vscrollbar = scrollcontainer.get_v_scrollbar()
	if vscrollbar.visible:
		rect_size.x = vscrollbar.rect_size.x
		visible = true
	else:
		visible = false
	
