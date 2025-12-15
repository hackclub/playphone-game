extends CanvasLayer

func _on_volume_value_changed(value: float) -> void:
	# Convert from linear slider range (0-100) to decibel range (-40 to 0)
	var db = lerp(-40.0, 0.0, value / 100.0)
	AudioServer.set_bus_volume_db(0, db)
	$volume_label.text = "Volume (" + str(int(value)) + "%)"
	
func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
func _ready() -> void:
	var current_db = AudioServer.get_bus_volume_db(0)
	# Convert from decibels (-40 to 0) back to slider range (0 to 100)
	var slider_value = inverse_lerp(-40.0, 0.0, current_db) * 100.0
	$Volume.value = slider_value
	$volume_label.text = "Volume (" + str(int(slider_value)) + "%)"
