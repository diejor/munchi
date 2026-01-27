extends AbilityBase

func hide() -> void:
	owner.visible = false
	owner.process_mode = Node.PROCESS_MODE_DISABLED

func _on_explosion_sound_finished() -> void:
	owner.queue_free.call_deferred()


func _on_used() -> void:
	animation_component.animation_finished.connect(hide)
