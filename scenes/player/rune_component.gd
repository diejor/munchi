class_name RuneComponent
extends Node2D

signal start_level

@export var points_to_start: int = 100
@onready var points: Label = %Points
@onready var start_level_button: Button = %StartLevelButton

var level_started: bool = false

func _init() -> void:
	unique_name_in_owner = true


var current_points: int:
	set(value):
		current_points = value
		if current_points >= points_to_start and not level_started:
			start_level_button.disabled = false
		else:
			start_level_button.disabled = true
			
		points.text = str(current_points)

var activated_runes: Array[RuneBase]

func _ready() -> void:
	current_points = 0
	start_level_button.pressed.connect(start_level.emit)


func _on_rune_activated(rune: RuneBase) -> void:
	current_points += rune.points
	activated_runes.append(rune)

func _on_rune_deactivate(rune: RuneBase) -> void:
	if current_points > 0:
		current_points -= - rune.points
	activated_runes.erase(rune)



func _on_start_level() -> void:
	start_level_button.disabled = true
	level_started = true
	for rune in activated_runes:
		rune.release_enemies()
