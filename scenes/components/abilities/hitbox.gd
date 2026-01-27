class_name Hitbox
extends Area2D

signal fired
signal cooled

@onready var ability: AbilityBase = find_owner_with_type(AbilityBase)

var character: CharacterBodyBase:
	get: return ability.owner
var combat: CombatComponent:
	get: return character.get_node("%CombatComponent")


func find_owner_with_type(type: Variant) -> Node:
	if is_instance_of(owner, type):
		return owner
	elif owner and is_instance_of(owner.owner, type):
		return owner.owner
	return null


func _ready() -> void:
	unique_name_in_owner = true
	body_entered.connect(_on_enemy_entered)
	monitoring = false


func fire() -> void:
	monitoring = true
	fired.emit()

func cool() -> void:
	monitoring = false
	cooled.emit()


func _on_enemy_entered(body: Node2D) -> void:
	var body_combat: CombatComponent = body.get_node("%CombatComponent")
	body_combat.take_damage(combat, ability)
	ability.enemy_hit.emit()
