extends NavigationAgent2D

func _ready() -> void:
	if get_tree().debug_collisions_hint:
		debug_enabled = true
	
	unique_name_in_owner = true
