@tool
@icon("walker_generator.svg")
class_name SceneBasedGenerator
extends GaeaGenerator2D
## Generates a world using a handcrafted Scene as the source of truth.
## Supports nested Node2Ds and TileMapLayers with different positions.
## A Mountain tile permanently blocks a coordinate, preventing future Grass layers from placing there.

@export var settings: WalkerGeneratorSettings
@export var source_scene: PackedScene

var _walked_tiles: PackedVector2Array

func generate(starting_grid: GaeaGrid = null) -> void:
	if Engine.is_editor_hint() and not editor_preview:
		push_warning("%s: Editor Preview is not enabled so nothing happened!" % name)
		return

	if not settings:
		push_error("%s doesn't have a settings resource" % name)
		return
		
	if not source_scene:
		push_error("%s doesn't have a source_scene assigned" % name)
		return
	
	if tile_size == Vector2i.ZERO:
		push_error("%s: Tile Size is zero, cannot calculate offsets." % name)
		return

	generation_started.emit()

	var _time_now: int = Time.get_ticks_msec()

	if starting_grid == null:
		erase()
	else:
		grid = starting_grid

	_generate_floor()
	_apply_modifiers(settings.modifiers)

	if is_instance_valid(next_pass):
		next_pass.generate(grid)
		return

	grid_updated.emit()
	generation_finished.emit()
	
	var _time_elapsed: int = Time.get_ticks_msec() - _time_now
	if OS.is_debug_build():
		print("%s: Generating took %s seconds" % [name, float(_time_elapsed) / 1000])


func erase() -> void:
	super.erase()
	_walked_tiles.clear()


### Steps ###

func _generate_floor() -> void:
	var instance = source_scene.instantiate()
	
	var valid_tiles := {}
	var blocked_tiles := {}
	
	# Start recursion with 0,0 offset
	_parse_layers_recursive(instance, valid_tiles, blocked_tiles, Vector2.ZERO)
	
	instance.free()
	
	_walked_tiles.clear()
	for pos in valid_tiles.keys():
		_walked_tiles.append(pos)
		grid.set_value(pos, settings.tile)


func _parse_layers_recursive(node: Node, valid_tiles: Dictionary, blocked_tiles: Dictionary, parent_offset: Vector2) -> void:
	var current_offset = parent_offset
	
	# If the node has a transform (Node2D), add its position to the offset.
	# We assume only Position is used (no Rotation/Scale).
	if node is Node2D:
		current_offset += node.position

	if node is TileMapLayer:
		var node_name = node.name.to_lower()
		var cells = node.get_used_cells()
		
		# Convert the accumulated pixel offset into grid coordinates
		var grid_offset = Vector2i(current_offset) / tile_size
		
		if "mountain" in node_name:
			for cell in cells:
				var abs_cell = cell + grid_offset
				blocked_tiles[abs_cell] = true
				valid_tiles.erase(abs_cell)
				
		elif "grass" in node_name:
			for cell in cells:
				var abs_cell = cell + grid_offset
				if not blocked_tiles.has(abs_cell):
					valid_tiles[abs_cell] = true

	# Pass the *current* offset down to children so they inherit the transform
	for child in node.get_children():
		_parse_layers_recursive(child, valid_tiles, blocked_tiles, current_offset)


### Editor ###

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray

	if not settings:
		warnings.append("Needs WalkerGeneratorSettings to work.")
	
	if not source_scene:
		warnings.append("Needs a Source Scene (PackedScene).")

	return warnings
