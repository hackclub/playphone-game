extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _new_scene_1 = preload("res://Levels/Level1.tscn").instantiate()
	$Level.set_scene("res://Levels/Level1.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
