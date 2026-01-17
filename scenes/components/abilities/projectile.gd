class_name ProjectileBase
extends StaticBody2D

@export var projectile_speed: float = 100.

@export_group("Animation")
@export var lifetime: float = 1.
@export var frames: int = 7
@export_group("")

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var hitbox: Hitbox:
	get: return %Hitbox

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


func _on_hitbox_body_entered(_body: Node2D) -> void:
	queue_free.call_deferred()
