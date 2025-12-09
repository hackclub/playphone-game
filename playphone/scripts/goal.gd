extends Area2D

@export var boost_strength: float = 800.0  # how high it launches


func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)


var b = null


func _on_body_entered(_body):
	call_deferred("_go_to_end")

func _go_to_end():
	get_tree().change_scene_to_file("res://Scenes/end.tscn")

func _on_body_exited(body):
	if body is CharacterBody2D:
		b = null


func _process(_delta: float) -> void:
	if b != null:
		b.velocity.y = -boost_strength
