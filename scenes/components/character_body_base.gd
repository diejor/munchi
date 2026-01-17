class_name CharacterBodyBase
extends CharacterBody2D

@export var movement_speed: float = 50.0
@export_exp_easing var mass: float = 15.0

func _init() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

func _ready() -> void:
	var combat: CombatComponent = get_node_or_null("%CombatComponent")
	if combat:
		combat.die.connect(_on_die)

func move_with_velocity(target_velocity: Vector2) -> void:
	var delta = get_physics_process_delta_time()
	
	velocity = velocity.lerp(target_velocity, mass * delta)
	move_and_slide()


func _on_die() -> void:
	collision_layer = 0
	collision_mask = 1
