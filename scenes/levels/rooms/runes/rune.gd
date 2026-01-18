class_name RuneBase
extends Node2D

@warning_ignore("unused_signal")
signal activate(rune: RuneBase)

@warning_ignore("unused_signal")
signal deactivate(rune: RuneBase)

@export var points: int = 15
@export var deactivated: Texture2D
@export var activated: Texture2D
@export var vanish_enemy_color: Color

@onready var rune_sprite: Sprite2D = %RuneSprite
@onready var area_2d: Area2D = %Area2D

@onready var is_active: bool = false

var player: CharacterPlayer:
	get: 
		return get_tree().current_scene.get_node("Player")

var player_rune_component: RuneComponent:
	get: return player.get_node("%RuneComponent")

@export var enemies: Array[CharacterNPC]


func _update_rune() -> void:
	if is_active:
		activate.emit()
	else:
		deactivate.emit()

func _ready() -> void:
	activate.connect(_on_activate.bind(self))
	deactivate.connect(_on_deactivate.bind(self))
	
	activate.connect(player_rune_component._on_rune_activated.bind(self))
	deactivate.connect(player_rune_component._on_rune_deactivate.bind(self))
	
	_update_rune()

func release_enemies() -> void:
	for enemy in enemies:
		enemy.modulate = Color.WHITE
		enemy.process_mode = Node.PROCESS_MODE_INHERIT
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_activate(_rune: RuneBase) -> void:
	rune_sprite.texture = activated
	for enemy in enemies:
		enemy.visible = true
		enemy.modulate = vanish_enemy_color


func _on_deactivate(_rune: RuneBase) -> void:
	rune_sprite.texture = deactivated
	for enemy in enemies:
		enemy.visible = false
		enemy.process_mode = Node.PROCESS_MODE_DISABLED


func _on_player_pressed_rune() -> void:
	is_active = not is_active
	_update_rune()
