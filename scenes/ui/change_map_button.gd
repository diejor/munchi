extends Button

@export_file var map: String

func _on_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred(map)
