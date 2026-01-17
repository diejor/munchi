extends CanvasLayer

@export var override_visibility: bool = true
@export var hide_owner: bool = false

func _ready() -> void:
	if override_visibility:
		visible = false
	owner.visibility_changed.connect(_on_tree_visibility_changed)
	for child in get_children():
		var no_pixel = child.get("no_pixel")
		if child.owner != self and no_pixel == null:
			child.reparent(%SubViewport)
	
	if hide_owner:
		owner.visible = false


func _on_tree_visibility_changed() -> void:
	if override_visibility:
		visible = owner.is_visible_in_tree()
