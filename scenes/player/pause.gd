extends Button

@onready var effects: CanvasModulate = %Effects
@onready var pause_menu: PanelContainer = %PauseMenu
@onready var hud: Control = %HUD


func _on_pressed() -> void:
	var paused: bool = not get_tree().paused
	get_tree().paused = paused
	effects.visible = paused
	pause_menu.visible = paused
	hud.visible = not paused
