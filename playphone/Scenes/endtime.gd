extends Label

func _ready():
	var scene := Globals.next_level
	var pb := getPB(scene)
	var end_time := Globals.last_time

	text = "Your Time: " + format_time(end_time) + "\n" + "Personal Best: " + format_time(pb)

func getPB(scene_path: String) -> float:
	var file := ConfigFile.new()
	var err := file.load("user://scores.cfg")

	if err != OK:
		return 0.0

	return file.get_value(scene_path, "bestTime", 0.0)

func format_time(t: float) -> String:
	var whole := int(t)
	@warning_ignore("integer_division")
	var minutes := whole / 60
	var seconds := whole % 60
	var ms := int((t - whole) * 100)
	return "%02d:%02d.%02d" % [minutes, seconds, ms]
