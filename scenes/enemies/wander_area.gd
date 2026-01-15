@tool
class_name WanderArea
extends CollisionShape2D

func _ready() -> void:
	assert(shape is CircleShape2D)
	assert(owner is Node2D)
	global_position = owner.global_position
	top_level = true
	disabled = true
	unique_name_in_owner = true

func get_wander_point() -> Vector2:
	var random_angle: float = randf() * TAU
	var random_radius: float = randf() * shape.radius

	var offset_x = random_radius * cos(random_angle)
	var offset_y = random_radius * sin(random_angle)

	var random_point = global_position + Vector2(offset_x, offset_y)

	return random_point
