class_name AbilityBase
extends Node

@warning_ignore("unused_signal")
signal enemy_hit

signal used
signal refreshed

@export var damage: int = 1
@export var no_animation: bool = false

@onready var combat_component: CombatComponent = owner.get_node("%CombatComponent")
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var can_use: bool = true

func _ready() -> void:
	refresh()
	if no_animation:
			animation_player.animation_finished.connect(refresh)


func try_use() -> AbilityBase:
	if can_use:
		can_use = false
		animation_player.play("use_ability")
		return self
	return null

func emit_used() -> void:
	used.emit()

func refresh(_ignore = null) -> void:
	can_use = true
	animation_player.play("RESET")
	refreshed.emit()
