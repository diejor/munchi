@tool
extends Node2D

@onready var loading_control: LoadingControl = %LoadingControl

@onready var generator: GaeaGenerator = %Generator
@onready var start_sound: AudioStreamPlayer2D = %StartSound

func _enter_tree() -> void:
	visible = false

func _ready() -> void:
	if not generator.generate_on_ready:
		generator.generation_finished.emit()
		loading_control.level_loaded.emit()

func _on_level_loaded() -> void:
	start_sound.play()
	visible = true
