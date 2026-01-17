@tool
@icon("walker_generator.svg")
class_name SceneBasedGenerator
extends GaeaGenerator2D
## Generates a world using a handcrafted Scene as the source of truth.
## - TileMapLayers: "Grass" layers add tiles, "Mountain" layers block them.
## - Other Scenes: Enemies/Powerups are instantiated into the Objects Container.
## - Supports nested transforms.

@export var settings: WalkerGeneratorSettings
@export var source_scene: PackedScene
@export var objects_container: Node2D

var _walked_tiles: PackedVector2Array

func generate(starting_grid: GaeaGrid = null) -> void:
	if Engine.is_editor_hint() and not editor_preview:
		push_warning("%s: Editor Preview is not enabled so nothing happened!" % name)
		return

	if not settings:
		push_error("%s: Missing settings resource." % name)
		return
		
	if not source_scene:
		push_error("%s: Missing source_scene." % name)
		return
	
	if tile_size == Vector2i.ZERO:
		push_error("%s: Tile Size is zero." % name)
		return

	generation_started.emit()
	var _time_now: int = Time.get_ticks_msec()

	if starting_grid == null:
		erase()
	else:
		grid = starting_grid

	# Clear previous objects if container exists
	_clear_objects()
	
	_generate_world()
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
	_clear_objects()


func _clear_objects() -> void:
	if not objects_container:
		return
		
	for child in objects_container.get_children():
		child.queue_free()


### Steps ###

func _generate_world() -> void:
	var instance = source_scene.instantiate()
	
	var valid_tiles := {}
	var blocked_tiles := {}
	
	# Start recursion. 
	# Note: We don't add 'instance' itself to the scene tree, so we pass it manually.
	_parse_node_recursive(instance, valid_tiles, blocked_tiles, Vector2.ZERO)
	
	instance.free()
	
	# Apply Tiles to Grid
	_walked_tiles.clear()
	for pos in valid_tiles.keys():
		_walked_tiles.append(pos)
		grid.set_value(pos, settings.tile)


func _parse_node_recursive(node: Node, valid_tiles: Dictionary, blocked_tiles: Dictionary, parent_offset: Vector2) -> void:
	var current_offset = parent_offset
	
	# 1. Update Offset
	# If this is a Node2D, its position contributes to the offset
	if node is Node2D:
		current_offset += node.position

	# 2. Check Node Type
	
	# CASE A: TileMapLayer (Terrain)
	if node is TileMapLayer:
		_process_tilemap_layer(node, current_offset, valid_tiles, blocked_tiles)
		# We still recurse in case a TileMapLayer has children (unlikely but possible)
		for child in node.get_children():
			_parse_node_recursive(child, valid_tiles, blocked_tiles, current_offset)

	# CASE B: Scene Instance (Enemy / Powerup / Prop)
	# If the node has a file path, it is an instance of another scene. 
	# We treat it as an Object and do NOT recurse inside it.
	elif node is Node2D and not node.scene_file_path.is_empty() and node != source_scene.get_state().get_node_instance(0):
		# (The check `node != source_scene...` ensures we don't try to spawn the root itself as an object)
		if objects_container:
			_spawn_object(node, current_offset)
		return # Stop recursion for this branch (atomic object)

	# CASE C: Structural Node (Folder)
	# It's a plain Node2D or Node used for grouping. We just recurse.
	else:
		for child in node.get_children():
			_parse_node_recursive(child, valid_tiles, blocked_tiles, current_offset)


func _process_tilemap_layer(layer: TileMapLayer, offset: Vector2, valid_tiles: Dictionary, blocked_tiles: Dictionary) -> void:
	var node_name = layer.name.to_lower()
	var cells = layer.get_used_cells()
	var grid_offset = Vector2i(offset) / tile_size
	
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


func _spawn_object(source_node: Node2D, global_pos: Vector2) -> void:
	# Duplicate the node. 
	# DUPLICATE_USE_INSTANTIATION (default) keeps the link to the original scene file 
	# if you were to save this generated scene, but here it just copies properties.
	var new_obj = source_node.duplicate()
	
	objects_container.add_child(new_obj)
	
	# Set owner if in editor to ensure visibility/saving if needed, 
	# though for runtime generation it's not strictly necessary.
	if Engine.is_editor_hint() and objects_container.owner:
		new_obj.owner = objects_container.owner
	
	# Reset transform to identity then apply the calculated global offset
	# This ensures we ignore the original local position relative to its old parent
	# and strictly place it where our recursive calculation says it should be.
	new_obj.position = global_pos


### Editor ###

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray

	if not settings:
		warnings.append("Needs WalkerGeneratorSettings to work.")
	
	if not source_scene:
		warnings.append("Needs a Source Scene (PackedScene).")
		
	if not objects_container:
		warnings.append("Objects Container is not assigned. Enemies/Objects won't spawn.")

	return warnings
