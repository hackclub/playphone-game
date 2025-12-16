extends Label

var time_elapsed : float = 0.0
var besttimes := ConfigFile.new()

func format_time(t: float) -> String:
	var whole := int(t)
	@warning_ignore("integer_division")
	var minutes := whole / 60
	var seconds := whole % 60
	var ms := int((t - whole) * 100)
	return "%02d:%02d.%02d" % [minutes, seconds, ms]

func saveTime():
	# saves last used scene aka last played level
	var scene := Globals.next_level
	
	# just in case
	if scene == null or scene == "":
		print("WARNING: next_level not set, PB not saved.")
		return
	
	print("Saving time for", scene)
	
	besttimes.load("user://scores.cfg")
	
	var old_pb: float = float(besttimes.get_value(scene, "bestTime", INF))
	
	# dont overwrite if slower than old pb
	if time_elapsed < old_pb:
		besttimes.set_value(scene, "bestTime", time_elapsed)
		besttimes.save("user://scores.cfg")
	
	# for "your time:"
	Globals.last_time = time_elapsed

func _process(delta):
	time_elapsed += delta
	text = format_time(time_elapsed)

func _notification(what):
	if what == NOTIFICATION_EXIT_TREE:
		saveTime()
