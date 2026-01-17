@tool
class_name SimpleSFX
extends AudioStreamPlayer2D

func _ready() -> void:
	bus = "SFX"

func _on_play_sfx() -> void:
	play()
