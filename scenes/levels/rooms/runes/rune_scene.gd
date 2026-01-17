@tool
class_name RuneScene
extends Node2D

@export var enemies: Array[CharacterNPC]:
	get:
		if not enemies.is_empty():
			return enemies
		
		for child in get_children():
			if child is CharacterNPC:
				enemies.append(child)
		
		return enemies
