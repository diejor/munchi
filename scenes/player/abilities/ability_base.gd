class_name AbilityBase
extends Node

signal enemy_hit
signal used
signal refreshed

@export var damage: int = 1
@export var no_animation: bool = false

@onready var hitbox: Area2D = %Hitbox
@onready var combat_component: CombatComponent = owner.get_node("%CombatComponent")
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var can_use: bool = true

func _ready() -> void:
	hitbox.body_entered.connect(_on_enemy_entered)
	refresh()
	if no_animation:
			animation_player.animation_finished.connect(refresh)


func _on_enemy_entered(body: Node2D) -> void:
	var body_combat: CombatComponent = body.get_node("%CombatComponent")
	body_combat.take_damage(combat_component, self)
	enemy_hit.emit()


func try_use() -> AbilityBase:
	if can_use:
		can_use = false
		used.emit()
		animation_player.play("use_ability")
		return self
	return null


func refresh(_ignore = null) -> void:
	can_use = true
	animation_player.play("RESET")
	refreshed.emit()
