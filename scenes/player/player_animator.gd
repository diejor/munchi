@tool
class_name PlayerAnimator
extends ArtAnimator

var is_prepared: bool = false

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if Input.is_action_just_pressed("prepare"):
		is_prepared = not is_prepared
