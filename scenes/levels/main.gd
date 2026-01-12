extends Node2D

@onready var walker_generator: WalkerGenerator = $WalkerGenerator

func _enter_tree() -> void:
	visible = false

func _ready() -> void:
	if not walker_generator.generate_on_ready:
		walker_generator.generation_finished.emit()

func _on_walker_generator_generation_finished() -> void:
	visible = true
