@tool
@icon("walker_generator.svg")
class_name SceneBasedGenerator
extends GaeaGenerator2D
## Generates a world using a fixed 2-level structure: Root -> Rooms -> Contents.
## 1. Iterates through "Rooms" (Children of Root).
## 2. Iterates through "Contents" (Children of Rooms).
## 3. Skips "Player" nodes.
## 4. Handles TileMapLayers (Grass/Mountain) and Game Objects separately.

@export var settings: WalkerGeneratorSettings
@export var source_scene: PackedScene
@export var objects_container: Node2D

var _walked_tiles: PackedVector2Array

func generate(starting_grid: GaeaGrid = null) -> void:
	if Engine.is_editor_hint() and not editor_preview:
		push_warning("%s: Editor Preview is not enabled." % name)
		return

	if not settings or not source_scene:
		push_error("%s: Missing settings or source_scene." % name)
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

	_clear_objects()
	_generate_world()
	_apply_modifiers(settings.modifiers)

	if is_instance_valid(next_pass):
		next_pass.generate(grid)
		return

	grid_updated.emit()
	generation_finished.emit()
	
	if OS.is_debug_build():
		var _time_elapsed: int = Time.get_ticks_msec() - _time_now
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


### Core Logic ###

func _generate_world() -> void:
	var temp_instance = source_scene.instantiate()
	
	var valid_tiles := {}
	var blocked_tiles := {}
	
	# LEVEL 1: Iterate through "Rooms" (Direct children of Root)
	for room in temp_instance.get_children():
		# Skip non-visual nodes or nodes that aren't Node2D (like AnimationPlayer, Timers etc at room root)
		if not room is Node2D: 
			continue
		
		var room_offset = room.position
		
		# LEVEL 2: Iterate through "Contents" (Children of the Room)
		for node in room.get_children():
			if not node is Node2D: 
				continue
				
			# --- FILTER: Skip Player ---
			if "player" in node.name.to_lower():
				continue

			# Calculate absolute position
			var global_pos = room_offset + node.position
			
			if node is TileMapLayer:
				# CASE A: Terrain
				_process_tilemap_layer(node, global_pos, valid_tiles, blocked_tiles)
			else:
				# CASE B: Game Object
				# Ensure we are only spawning valid objects, not internal tools
				if objects_container:
					_spawn_object(node, global_pos)

	temp_instance.free()
	
	# Apply final tiles to Grid
	_walked_tiles.clear()
	for pos in valid_tiles.keys():
		_walked_tiles.append(pos)
		grid.set_value(pos, settings.tile)


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
	# Duplicate with DUPLICATE_SCRIPTS | DUPLICATE_SIGNALS | DUPLICATE_GROUPS
	var new_obj = source_node.duplicate()
	
	new_obj.position = global_pos
	
	objects_container.add_child(new_obj)
	
	if Engine.is_editor_hint() and objects_container.owner:
		new_obj.owner = objects_container.owner

### Editor ###

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	if not settings: warnings.append("Needs WalkerGeneratorSettings.")
	if not source_scene: warnings.append("Needs a Source Scene.")
	if not objects_container: warnings.append("Needs Objects Container.")
	return warnings
