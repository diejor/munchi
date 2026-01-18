@tool
@icon("walker_generator.svg")
class_name SceneBasedGenerator
extends GaeaGenerator2D

@export var settings: WalkerGeneratorSettings
@export var source_scene: PackedScene
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
	if not source_scene:
		push_error("%s: Missing source_scene." % name)
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
	var temp_source = source_scene.instantiate()
	var valid_tiles := {}
	var blocked_tiles := {}

	for room_source in temp_source.get_children():
		if not room_source is Node2D:
			continue

		var spawned_room = room_source.duplicate()
		if objects_container:
			objects_container.add_child(spawned_room)
			spawned_room.position = room_source.position

		for child in spawned_room.get_children():
			if child is TileMapLayer:
				var absolute_pos = spawned_room.position + child.position
				_extract_terrain_data(child, absolute_pos, valid_tiles, blocked_tiles)
				child.queue_free()

	temp_source.free()

	_apply_tiles_to_grid(valid_tiles)


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
	if not source_scene: warnings.append("Needs a Source Scene.")
	if not objects_container: warnings.append("Needs Objects Container.")
	return warnings
