extends CanvasLayer

func _ready() -> void:
	visible = false
	owner.visibility_changed.connect(_on_tree_visibility_changed)
	for child in get_children():
		if child.owner != self:
			child.reparent(%SubViewport)


func _on_tree_visibility_changed() -> void:
	visible = owner.is_visible_in_tree()
