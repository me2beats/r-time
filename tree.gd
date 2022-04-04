extends Tree


func _ready():
	var root = create_item()
	for i in 10:
		var item = create_item(root)
		item.set_text(0, "hello" )

	print(range(10,8,-1))
