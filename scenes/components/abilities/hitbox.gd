class_name Hitbox
extends Area2D

var ability: AbilityBase

var character: CharacterBodyBase:
	get: return ability.owner
var combat: CombatComponent:
	get: return character.get_node("%CombatComponent")

@onready var impact_timer: Timer = %ImpactTimer

func find_owner_with_typed(type: Variant) -> Node:
	if is_instance_of(owner, type):
		return owner
	elif owner and is_instance_of(owner.owner, type):
		return owner.owner
	return null

func _ready() -> void:
	ability = find_owner_with_typed(AbilityBase)
	
	ability.animation_component.marker.connect(fire)
	body_entered.connect(_on_enemy_entered)
	
	monitoring = false
	impact_timer.timeout.connect(set.bind("monitoring", false))

func fire(_event: Variant) -> void:
	monitoring = true
	impact_timer.start()

func _on_enemy_entered(body: Node2D) -> void:
	var body_combat: CombatComponent = body.get_node("%CombatComponent")
	body_combat.take_damage(combat, ability)
	ability.enemy_hit.emit()
