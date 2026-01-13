class_name AbilityBase
extends Node

signal enemy_hit
signal used

@onready var hitbox: Area2D = %Hitbox
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var combat_component: CombatComponent = %CombatComponent

var can_use: bool = true

func _ready() -> void:
	var refresh = func(_anim_name): can_use = true
	animation_player.animation_finished.connect(refresh)
	hitbox.body_entered.connect(_on_enemy_entered)

func _on_enemy_entered(body: Node2D) -> void:
	var body_combat: CombatComponent = body.get_node("%CombatComponent")
	body_combat.take_damage(combat_component)
	enemy_hit.emit()

func try_use() -> void:
	if can_use:
		can_use = false
		used.emit()
		animation_player.play("attack")
