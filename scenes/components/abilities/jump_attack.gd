extends AbilityBase

@export var jump_force: float = 125.


func _on_fired() -> void:
	character.velocity = character.facing_vector * jump_force
