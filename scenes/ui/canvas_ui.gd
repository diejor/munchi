extends CanvasLayer

@export var override_visibility: bool = true

func _ready() -> void:
	if override_visibility:
		visible = false
	owner.visibility_changed.connect(_on_tree_visibility_changed)
	for child in get_children():
		if child.owner != self:
			child.reparent(%SubViewport)


func _on_tree_visibility_changed() -> void:
	if override_visibility:
		visible = owner.is_visible_in_tree()
