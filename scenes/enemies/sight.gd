class_name SightComponent
extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var ray_cast: RayCast2D = $RayCast2D

var tracked_player: Node2D
var in_los: bool
var last_seen: Vector2:
	get: return ray_cast.target_position + owner.global_position

func _physics_process(_delta: float) -> void:
	if tracked_player != null:
		ray_cast.target_position = tracked_player.global_position - owner.global_position
		in_los = not ray_cast.is_colliding()
	else:
		in_los = false

func _on_body_entered(body: Node2D) -> void:
	tracked_player = body

func _on_body_exited(_body: Node2D) -> void:
	tracked_player = null
