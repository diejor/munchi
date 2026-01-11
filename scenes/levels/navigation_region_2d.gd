@tool
extends NavigationRegion2D

func _on_walker_generator_generation_finished() -> void:
	if get_tree():
		await get_tree().physics_frame
		await get_tree().physics_frame
	
	bake_navigation_polygon()
