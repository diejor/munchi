@tool
extends Control

@onready var loading_screen: ColorRect = $LoadingScreen
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var generator_progress: ProgressBar = $GeneratorProgress

signal level_loaded

func _ready() -> void:
	_reset_state()

func _on_generation_progress(progress: float) -> void:
	generator_progress.value = progress * 100.


func _on_area_rendered(_area: Rect2i) -> void:
	level_loaded.emit()
	animation_player.play("enter_level")

func _reset_state() -> void:
	generator_progress.value = 0
	animation_player.play("RESET")

func _on_generation_started() -> void:
	_reset_state()
