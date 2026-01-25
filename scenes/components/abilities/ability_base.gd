class_name AbilityBase
extends Node

@warning_ignore("unused_signal")
signal enemy_hit

signal used
signal refreshed

@export var damage: int = 1

var character: CharacterBodyBase:
	get: return owner
var combat_component: CombatComponent:
	get: return character.get_node("%CombatComponent")
var animation_component: AnimatedSpritePlayer:
	get: return character.get_node("%AnimationComponent")

var can_use: bool = true

func _ready() -> void:
	refresh()


func try_use() -> AbilityBase:
	if can_use:
		can_use = false
		return self
	return null

func emit_used() -> void:
	used.emit()

func refresh(_ignore = null) -> void:
	can_use = true
	refreshed.emit()
