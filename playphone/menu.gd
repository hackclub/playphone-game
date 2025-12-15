extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/controls.tscn")

func _on_quit_pressed() -> void:
	var osName = OS.get_name();
	# osName = "Web"
	# uncomment for if need de the bug
	if osName == "Web":
		get_tree().change_scene_to_file("res://Scenes/webExit.tscn")
	else:
		get_tree().quit()

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")
