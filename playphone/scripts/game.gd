extends Node2D
#var _new_scene_1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globals.next_level == "":
		#_new_scene_1 = preload("res://Levels/Level1.tscn").instantiate()
		# what was that for?
		print('uh oh when loading level')
		Globals.next_level = "res://Levels/Level1.tscn"
	$Level.set_scene(Globals.next_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
