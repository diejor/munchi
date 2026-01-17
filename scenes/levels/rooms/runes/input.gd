extends Node2D

@onready var area_2d: Area2D = %Area2D

@onready var rune_base: RuneBase = $".."

signal player_pressed_rune

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and area_2d.has_overlapping_bodies():
		player_pressed_rune.emit()
