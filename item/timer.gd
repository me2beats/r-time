extends Timer

#onready var sound = $"../Sound"

# TODO: several options - sound play times or play sound during x time
# maybe rising volume as well ?

var sound_play_times = 100
var pause_time = 0

func _on_timeout():
	for i in sound_play_times:
		var sound = $"../Sound"
		sound.play()
		yield(sound, "finished")
		if pause_time:
			yield(get_tree().create_timer(pause_time), "timeout")
		
		
