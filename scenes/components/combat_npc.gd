class_name CombatNPC
extends CombatComponent

func is_valid_action(action: StringName) -> bool:
	for ability in abilities.get_children():
		if action == ability.name:
			return true
	
	return false

func use_ability(action: StringName) -> bool:
	assert(is_valid_action(action))
	var used_ability: AbilityBase = try_use_ability(action)
	if is_instance_valid(used_ability):
		ability_used.emit(used_ability)
		return true
	
	return false
