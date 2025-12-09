extends GridContainer

@onready var LevelContainerSample = $LevelContainerSample
@onready var LevelSample = $LevelContainerSample/LevelSample

func _ready():
	main()

func main():
	var dir := DirAccess.open("res://Levels")
	if dir == null:
		return

	dir.list_dir_begin()
	var file := dir.get_next()

	while file != "":
		# loop through every level file in res://levels and automatically clone to gridcontainer
		if not dir.current_is_dir() and file.ends_with(".tscn"):
			var container := LevelContainerSample.duplicate()
			var button := container.get_node("LevelSample")

			var number := file.trim_prefix("Level").trim_suffix(".tscn")
			button.text = number
			
			# connects button click to level switch
			button.connect("pressed", func():
				Globals.next_level = "res://Levels/" + file
				get_tree().change_scene_to_file("res://Scenes/game.tscn")
			)

			add_child(container)

		file = dir.get_next()
	
	# sample no longer needed
	LevelContainerSample.queue_free();
	dir.list_dir_end()
