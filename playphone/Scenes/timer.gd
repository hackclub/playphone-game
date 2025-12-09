extends Label

var time_elapsed : float = 0.0

func format_time(t: float) -> String:
	@warning_ignore("integer_division")
	var minutes = int(t) / 60
	var seconds = int(t) % 60
	var milliseconds = int((t - int(t)) * 100)

	return "%02d:%02d.%02d" % [minutes, seconds, milliseconds]

func _process(delta):
	time_elapsed += delta
	text = format_time(time_elapsed)
