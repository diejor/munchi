class_name CharacterPlayer
extends CharacterBodyBase

@onready var combat: CombatComponent = %CombatComponent


func _enter_tree() -> void:
	if self != get_tree().current_scene.get_node_or_null("Player"):
		queue_free()

func _ready() -> void:
	super._ready()
	visibility_changed.emit()


func _physics_process(_delta: float) -> void:
	var input: Vector2
	if not combat.is_using_ability() and not combat.is_dead:
		input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
	if not input.is_zero_approx():
		facing_vector = input
	
	var target_velocity: Vector2 = input * movement_speed
	move_with_velocity(target_velocity)
