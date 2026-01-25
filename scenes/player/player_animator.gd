@tool
class_name PlayerAnimator
extends ArtAnimator

var is_prepared: bool = false


func _ready() -> void:
	super._ready()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if Input.is_action_just_pressed("prepare"):
		is_prepared = not is_prepared
	set("parameters/prepared_idle/blend_position", character.facing_vector)
	set("parameters/prepared_walk/blend_position", character.facing_vector)
