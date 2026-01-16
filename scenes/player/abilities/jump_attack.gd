extends AbilityBase

@export var jump_force: float = 125.
@onready var character: CharacterBody2D = owner


func _on_used() -> void:
	character.velocity = character.facing_vector * jump_force
