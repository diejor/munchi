extends CombatComponent

func _physics_process(_delta: float) -> void:
	for ability in abilities.get_children():
		if Input.is_action_just_pressed(ability.name):
			var did_use: AbilityBase = ability.try_use()
			if did_use != null:
				ability_used.emit(ability)
				current_ability = did_use
				did_use.refreshed.connect(consume_ability.bind(did_use))
