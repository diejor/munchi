class_name ArtAnimator
extends AnimationTree

var is_moving: bool = false

func on_update(input: Vector2) -> void:
	if not input.is_zero_approx():
		set("parameters/Idle/blend_position", input)
		set("parameters/Walk/blend_position", input)
	is_moving = not input.is_zero_approx()
