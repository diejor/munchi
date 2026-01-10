extends CanvasLayer

func _ready() -> void:
	for child in get_children():
		if child.owner != self:
			child.reparent(%SubViewport)
