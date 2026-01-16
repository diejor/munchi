@tool
extends HBoxContainer

@onready var h_slider: HSlider = %HSlider
@onready var bus_label: Label = %BusLabel

@onready var bus: StringName:
	get: return bus_label.text
	set(bus_name): bus_label.text = bus_name

@onready var bus_idx: int:
	get: return AudioServer.get_bus_index(bus)

@onready var volume_db: float:
	get:
		return AudioServer.get_bus_volume_db(bus_idx)
	set(db):
		AudioServer.set_bus_volume_db(bus_idx, db)

func _ready() -> void:
	# Force load the layout to see if it applies
	var path = ProjectSettings.get_setting("audio/buses/default_bus_layout")
	print("Project setting path: ", ResourceUID.uid_to_path(path))
	
	if FileAccess.file_exists(path):
		var layout = load(path)
		AudioServer.set_bus_layout(layout)
		print("Forced reload of bus layout.")

	if not bus.is_empty():
		assert(is_valid_bus(bus), "Bus name '%s' not found!" % bus)
		
		h_slider.value = db_to_linear(volume_db)
		if OS.is_debug_build():
			print("getting value: ", h_slider.value)
	
	h_slider.value_changed.connect(_on_slider_value_changed)

func _on_slider_value_changed(value: float) -> void:
	volume_db = linear_to_db(value)

func get_bus_names() -> Array[StringName]:
	var busses: Array[StringName] = []
	for bus_index in AudioServer.bus_count:
		busses.append(AudioServer.get_bus_name(bus_index))
	return busses

func is_valid_bus(bus_name: String) -> bool:
	return bus_name in get_bus_names()
