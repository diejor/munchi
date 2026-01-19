@tool
@icon("walker_generator.svg")
class_name SceneBasedGenerator
extends GaeaGenerator2D

@export var settings: WalkerGeneratorSettings
## A pool of source scenes to randomly pick from.
@export var source_scenes: Array[PackedScene]
@export var objects_container: Node2D

var _walked_tiles: PackedVector2Array

func generate(starting_grid: GaeaGrid = null) -> void:
	if Engine.is_editor_hint() and not editor_preview:
		return

	if not _validate_dependencies():
		return

	generation_started.emit()
	var time_start = Time.get_ticks_msec()

	if starting_grid == null:
		erase()
	else:
		grid = starting_grid

	_clear_objects()
	_generate_world()
	_apply_modifiers(settings.modifiers)

	if is_instance_valid(next_pass):
		next_pass.generate(grid)
		return

	grid_updated.emit()
	generation_finished.emit()
	
	if OS.is_debug_build():
		var duration = (Time.get_ticks_msec() - time_start) / 1000.0
		print("%s: Generating took %s seconds" % [name, duration])


func erase() -> void:
	super.erase()
	_walked_tiles.clear()
	_clear_objects()


func _validate_dependencies() -> bool:
	if not settings:
		push_error("%s: Missing settings resource." % name)
		return false
	if source_scenes.is_empty():
		push_error("%s: No source scenes assigned in the pool." % name)
		return false
	if tile_size == Vector2i.ZERO:
		push_error("%s: Tile Size cannot be zero." % name)
		return false
	return true


func _clear_objects() -> void:
	if not objects_container:
		return
	for child in objects_container.get_children():
		child.queue_free()


func _generate_world() -> void:
	var random_source = source_scenes.pick_random()
	if not random_source:
		return
		
	var temp_instance = random_source.instantiate()
	var valid_tiles := {}
	var blocked_tiles := {}

	for room_source in temp_instance.get_children():
		if not room_source is Node2D:
			continue

		var spawned_room = room_source.duplicate()
		if objects_container:
			objects_container.add_child(spawned_room)
			spawned_room.owner = objects_container
			spawned_room.position = room_source.position

		_process_room_recursive(spawned_room, spawned_room, valid_tiles, blocked_tiles)

	temp_instance.free()

	_apply_tiles_to_grid(valid_tiles)


func _process_room_recursive(node: Node, room_root: Node2D, valid_tiles: Dictionary, blocked_tiles: Dictionary) -> void:
	if "player" in node.name.to_lower():
		node.queue_free()
		return

	if node is TileMapLayer:
		var absolute_pos = room_root.position + (node.global_position - room_root.global_position)
		absolute_pos = objects_container.to_local(node.to_global(Vector2.ZERO))
		
		_extract_terrain_data(node, absolute_pos, valid_tiles, blocked_tiles)
		node.queue_free()
		return

	for child in node.get_children():
		_process_room_recursive(child, room_root, valid_tiles, blocked_tiles)


func _extract_terrain_data(layer: TileMapLayer, offset: Vector2, valid_tiles: Dictionary, blocked_tiles: Dictionary) -> void:
	var layer_name = layer.name.to_lower()
	var used_cells = layer.get_used_cells()
	var grid_offset = Vector2i(offset) / tile_size

	if "mountain" in layer_name:
		for cell in used_cells:
			var abs_cell = cell + grid_offset
			blocked_tiles[abs_cell] = true
			valid_tiles.erase(abs_cell)
			
	elif "grass" in layer_name:
		for cell in used_cells:
			var abs_cell = cell + grid_offset
			if not blocked_tiles.has(abs_cell):
				valid_tiles[abs_cell] = true


func _apply_tiles_to_grid(valid_tiles: Dictionary) -> void:
	_walked_tiles.clear()
	for pos in valid_tiles.keys():
		_walked_tiles.append(pos)
		grid.set_value(pos, settings.tile)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	if not settings: warnings.append("Needs WalkerGeneratorSettings.")
	if source_scenes.is_empty(): warnings.append("Needs at least one Source Scene in the pool.")
	if not objects_container: warnings.append("Needs Objects Container.")
	return warnings
