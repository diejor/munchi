class_name CharacterBodyBase
extends CharacterBody2D

@export var movement_speed: float = 50.0
@export_exp_easing var mass: float = 15.0

func _init() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

func move_with_velocity(target_velocity: Vector2) -> void:
	var delta = get_physics_process_delta_time()
	
	velocity = velocity.lerp(target_velocity, mass * delta)
	move_and_slide()
