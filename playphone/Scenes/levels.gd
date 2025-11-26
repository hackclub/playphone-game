extends Control
@export_file("*.tscn") var lvl_path: String

func _on_pressed() -> void:
	print("level button clicked "+lvl_path)
	Globals.next_level = lvl_path
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
