@tool
extends Node2D

@onready var loading_control: Control = %LoadingControl

@onready var walker_generator: WalkerGenerator = $WalkerGenerator

func _enter_tree() -> void:
	visible = false

func _ready() -> void:
	if not walker_generator.generate_on_ready:
		walker_generator.generation_finished.emit()

func _on_level_loaded() -> void:
	visible = true
