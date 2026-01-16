extends CombatComponent

func _physics_process(_delta: float) -> void:
	for ability in abilities.get_children():
		if Input.is_action_just_pressed(ability.name):
			var did_use: AbilityBase = ability.try_use()
			if is_instance_valid(did_use):
				ability_used.emit(ability)
