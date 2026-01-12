class_name CombatComponent
extends Node

@export var abilities: Dictionary[StringName, AbilityBase]

signal damage_taken
signal heart_restored

@export var health: int

func _ready() -> void:
	unique_name_in_owner = true

func _physics_process(_delta: float) -> void:
	for action in abilities.keys():
		if Input.is_action_just_pressed(action):
			abilities[action].try_use()


func take_damage() -> void:
	damage_taken.emit()
	
func restore_health() -> void:
	heart_restored.emit()
