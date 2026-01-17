class_name ProjectileBase
extends StaticBody2D

@export var projectile_speed: float = 50.

@export_group("Animation")
@export var lifetime: float = 2.
@export var frames: int = 7

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

var direction: Vector2

func _ready() -> void:
	animate_and_die()
	
func _physics_process(delta: float) -> void:
	animation_tree.set("parameters/projectile/blend_position", direction)
	var motion: Vector2 = projectile_speed * delta * direction
	var collision: KinematicCollision2D = move_and_collide(motion)
	if is_instance_valid(collision):
		queue_free.call_deferred()

func animate_and_die() -> void:
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(animated_sprite_2d, "frame", frames - 1, lifetime).from(0)
	tween.tween_callback(queue_free)
