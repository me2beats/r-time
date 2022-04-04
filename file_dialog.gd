extends FileDialog


var item_idx:int
var signal_to_emit_on_confirm:Array

func _ready():
	get_tree().connect("files_dropped", self, "on_files_dropped")

func on_files_dropped(files, _scr):
	var file:String = files[0]
	if !file.get_extension() in ["mp3", "wav", "ogg"]: return
	current_path = file


# currently works only for path
func _on_FileDialog_file_selected(path):
	signal_to_emit_on_confirm[0].emit_signal(signal_to_emit_on_confirm[1], item_idx, current_path)

