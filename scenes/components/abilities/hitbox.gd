class_name Hitbox
extends Area2D

@export var ability: AbilityBase
var character: CharacterBodyBase:
	get: return ability.owner
var combat: CombatComponent:
	get: return character.get_node("%CombatComponent")

func _ready() -> void:
	body_entered.connect(_on_enemy_entered)

func _on_enemy_entered(body: Node2D) -> void:
	var body_combat: CombatComponent = body.get_node("%CombatComponent")
	body_combat.take_damage(combat, ability)
	ability.enemy_hit.emit()
