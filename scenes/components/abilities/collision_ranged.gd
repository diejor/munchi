@tool
class_name ProjectileHitbox
extends CollisionShape2D

@onready var hitbox: Area2D = get_parent()
@onready var projectile: ProjectileBase = hitbox.get_parent()

func _ready() -> void:
	var other_c: CollisionShape2D = projectile.get_node("CollisionShape2D")
	shape = other_c.shape
	scale = other_c.scale * 1.5
