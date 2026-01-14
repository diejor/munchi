extends Button

@export_file var scene_path: String

func _ready() -> void:
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)
	

func _on_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred(scene_path)
	get_tree().paused = false
