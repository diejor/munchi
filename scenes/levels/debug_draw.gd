@tool
extends Node2D

var circles: Array[Vector2]

func _draw() -> void:
	for pos in circles:
		draw_circle(pos, 10, Color.RED, false)
