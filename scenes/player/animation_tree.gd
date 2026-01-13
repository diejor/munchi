class_name ArtAnimator
extends AnimationTree

@onready var player: CharacterBody2D = owner.owner

var is_moving: bool = false

var playback: AnimationNodeStateMachinePlayback = get("parameters/playback")

func check_abilities_animations(combat: CombatComponent) -> bool:
	for ability in combat.abilities:
		assert(tree_root.has_node(ability.ability_name))
	
	return true
	
func _ready() -> void:
	assert(tree_root is AnimationNodeStateMachine)
	var combat: CombatComponent = player.get_node_or_null("%CombatComponent")
	if combat:
		combat.ability_used.connect(_on_ability_used)
		assert(check_abilities_animations(combat))

func _physics_process(_delta: float) -> void:
	set("parameters/idle/blend_position", player.facing_vector)
	set("parameters/walk/blend_position", player.facing_vector)
	set("parameters/attack/blend_position", player.facing_vector)
	
	is_moving = not player.velocity.is_zero_approx()

func _on_ability_used(ability_name: StringName) -> void:
	playback.travel(ability_name)
