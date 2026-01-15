extends ProgressBar

func _ready() -> void:
	if not get_tree().debug_collisions_hint:
		queue_free()
