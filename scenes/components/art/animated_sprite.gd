@tool
@icon("res://scenes/components/art/icon.png")
class_name AnimatedSpritePlayer
extends AnimatedSprite2D

signal marker(event: Variant)

func mark(event: Variant) -> void:
	marker.emit(event)

### Configuration
@export var animation_player: AnimationPlayer

## If true, adding/removing frames in the SpriteFrames panel will instantly update the AnimationPlayer for the active animation.
@export var auto_sync: bool = false

## Button to manually sync only the currently selected animation.
@export_tool_button("Sync Current Animation", "Callable")
var sync_current = sync_current_animation

## Button to sync ALL animations found in the SpriteFrames resource.
@export_tool_button("Sync ALL Animations", "Callable")
var sync_all = sync_all_animations

### Lifecycle

func _ready() -> void:
	unique_name_in_owner = true
	if sprite_frames:
		_connect_signals()
	
	if not Engine.is_editor_hint():
		name = "AnimationComponent"

func _set(property: StringName, value: Variant) -> bool:
	if property == "sprite_frames" and value != sprite_frames:
		if sprite_frames and sprite_frames.changed.is_connected(_on_sprite_frames_changed):
			sprite_frames.changed.disconnect(_on_sprite_frames_changed)
		
		sprite_frames = value
		
		if sprite_frames:
			_connect_signals()
		
		if auto_sync and Engine.is_editor_hint():
			sync_current_animation.call_deferred()
			
		return true
	return false

func _connect_signals() -> void:
	if not sprite_frames.changed.is_connected(_on_sprite_frames_changed):
		sprite_frames.changed.connect(_on_sprite_frames_changed)

func _on_sprite_frames_changed() -> void:
	if auto_sync and Engine.is_editor_hint():
		sync_current_animation.call_deferred()

### Core Logic

func sync_current_animation() -> void:
	if not Engine.is_editor_hint(): return
	if not _validate_dependencies(): return
	
	_sync_single_animation(animation)

func sync_all_animations() -> void:
	if not Engine.is_editor_hint(): return
	if not _validate_dependencies(): return
	
	var all_anims = sprite_frames.get_animation_names()
	print("AnimatedSpritePlayer: Starting sync for %d animations..." % all_anims.size())
	
	for anim_name in all_anims:
		_sync_single_animation(anim_name)
		
	print("AnimatedSpritePlayer: Sync All Complete.")

# The worker function that processes a specific animation name
func _sync_single_animation(anim_name: StringName) -> void:
	if not sprite_frames.has_animation(anim_name):
		push_warning("AnimatedSpritePlayer: Animation '%s' not found in SpriteFrames." % anim_name)
		return

	var frame_count := sprite_frames.get_frame_count(anim_name)
	var fps := sprite_frames.get_animation_speed(anim_name)
	
	var frame_duration := 1.0 / fps if fps > 0 else 0.1
	var total_length := frame_count * frame_duration
	var loop_mode = Animation.LOOP_LINEAR if sprite_frames.get_animation_loop(anim_name) else Animation.LOOP_NONE

	# Get Resource
	var anim_resource := _get_or_create_animation(anim_name)
	
	# Apply Settings
	anim_resource.step = frame_duration
	anim_resource.length = total_length
	anim_resource.loop_mode = loop_mode
	
	# Apply Tracks
	var path_prefix = _get_relative_path()
	
	# Track A: The "animation" string property
	_update_track(
		anim_resource, 
		str(path_prefix) + ":animation", 
		[0.0], 
		[anim_name]
	)
	
	# Track B: The "frame" integer property
	var times: PackedFloat32Array = []
	var values: Array = []
	for i in range(frame_count):
		times.append(i * frame_duration)
		values.append(i)
		
	_update_track(
		anim_resource, 
		str(path_prefix) + ":frame", 
		times, 
		values
	)
	
	print("AnimatedSpritePlayer: Synced '%s' (Frames: %d | FPS: %.2f)" % [anim_name, frame_count, fps])

### Helpers

func _validate_dependencies() -> bool:
	if not animation_player:
		push_warning("AnimatedSpritePlayer: No AnimationPlayer assigned.")
		return false
	if not sprite_frames:
		push_warning("AnimatedSpritePlayer: No SpriteFrames assigned.")
		return false
	return true

func _get_or_create_animation(anim_name: StringName) -> Animation:
	var library: AnimationLibrary
	
	if animation_player.has_animation_library(""):
		library = animation_player.get_animation_library("")
	else:
		library = AnimationLibrary.new()
		animation_player.add_animation_library("", library)
		
	if library.has_animation(anim_name):
		return library.get_animation(anim_name)
	else:
		var new_anim = Animation.new()
		library.add_animation(anim_name, new_anim)
		return new_anim

func _get_relative_path() -> NodePath:
	var root = animation_player.get_parent()
	if not root: return NodePath(".")
	return root.get_path_to(self)

func _update_track(anim: Animation, track_path: String, times: PackedFloat32Array, values: Array) -> void:
	var track_idx = anim.find_track(track_path, Animation.TYPE_VALUE)
	
	if track_idx == -1:
		track_idx = anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_path(track_idx, track_path)
	
	anim.track_set_interpolation_type(track_idx, Animation.INTERPOLATION_NEAREST)
	anim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)

	while anim.track_get_key_count(track_idx) > 0:
		anim.track_remove_key(track_idx, 0)
		
	for i in range(times.size()):
		anim.track_insert_key(track_idx, times[i], values[i])
