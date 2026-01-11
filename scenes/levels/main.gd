extends Node2D

func _enter_tree() -> void:
	visible = false

func _on_walker_generator_generation_finished() -> void:
	visible = true
