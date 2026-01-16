@tool
extends BTAction

@export var ability_name: StringName

var _was_successful: bool = false

func _generate_name() -> String:
	return "UseAbility ➜%s" % [
		LimboUtility.decorate_var(ability_name)
	]

func _enter() -> void:
	var combat_npc: CombatNPC = agent.get_node("%CombatComponent")
	_was_successful = combat_npc.use_ability(ability_name)
	pass

func _tick(_delta: float) -> Status:
	if not _was_successful:
		return FAILURE
		
	var combat_npc: CombatNPC = agent.get_node("%CombatComponent")
	
	# CombatComponent manages the "current_ability" state via signals.
	# When ability_finished is emitted (via consume_ability), is_using_ability() becomes false.
	if combat_npc.is_using_ability():
		return RUNNING
	
	return SUCCESS
