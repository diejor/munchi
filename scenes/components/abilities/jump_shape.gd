@tool
extends CollisionShape2D

var character: CharacterBodyBase:
	get:
		if owner != null and owner.owner != null:
			return owner.owner
		return null


func _ready() -> void:
	if is_instance_valid(character):
		var c_shape: CollisionShape2D = character.get_node("CollisionShape2D")
		shape = c_shape.shape
		transform = c_shape.transform
		scale *= 1.5
