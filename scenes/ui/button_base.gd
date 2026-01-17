class_name ButtonBase
extends Button

@export var on_press_sound: AudioStream = preload("uid://cksxqnhipfw6t")

func _init() -> void:
	pressed.connect(_on_base_pressed)
	
func _on_base_pressed() -> void:
	AudioManager.playback.play_stream(on_press_sound)
