class_name SightComponent
extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var character: CharacterNPC = owner
@onready var combat: CombatNPC = %CombatComponent

var tracked_player: Node2D
var in_los: bool
var last_seen: Vector2:
	get: return ray_cast.target_position + owner.global_position

func _ready() -> void:
	unique_name_in_owner = true

func _physics_process(_delta: float) -> void:
	if tracked_player != null:
		ray_cast.target_position = tracked_player.global_position - owner.global_position
		in_los = not ray_cast.is_colliding()
		
		if not combat.is_dead:
			character.facing_vector = ray_cast.global_position.direction_to(tracked_player.global_position)
	else:
		in_los = false
		character.facing_vector = character.velocity
	
	character.facing_vector = snap_to_8_directions(character.facing_vector)

func _on_body_entered(body: Node2D) -> void:
	tracked_player = body

func _on_body_exited(_body: Node2D) -> void:
	tracked_player = null

func snap_to_8_directions(vector: Vector2) -> Vector2:
	if vector.is_zero_approx():
		return Vector2.ZERO

	# Snap the angle to increments of 45 degrees (PI/4 radians)
	var angle := vector.angle()
	var snapped_angle := snappedf(angle, PI / 4.0)

	return Vector2.from_angle(snapped_angle)
