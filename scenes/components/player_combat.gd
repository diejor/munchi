extends CombatComponent

@export_file var leave_scene: String

func _physics_process(_delta: float) -> void:
	if is_dead:
		return
	for ability in abilities.get_children():
		if Input.is_action_just_pressed(ability.name):
			var did_use: AbilityBase = ability.try_use()
			if is_instance_valid(did_use):
				ability_used.emit(ability)


func _on_dissapearing() -> void:
	get_tree().change_scene_to_file.call_deferred(leave_scene)
