class_name ArtAnimator
extends AnimationTree

@onready var character: CharacterBodyBase = owner.owner
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@onready var combat: CombatComponent = character.get_node_or_null("%CombatComponent")

var is_moving: bool = false
var is_dead: bool = false
var _playback: AnimationNodeStateMachinePlayback = get("parameters/playback")

var _blend_positions: Array[Dictionary]


func _ready() -> void:
	active = true
	assert(tree_root is AnimationNodeStateMachine)
	
	if combat:
		combat.ability_used.connect(_on_ability_used)
		combat.die.connect(_on_die)
		for ability in combat.abilities.get_children():
			assert(tree_root.has_node(ability.name))
	
	var blend_positions_filter := func(prop: Dictionary):
		var pname: String = prop["name"]
		return pname.begins_with("parameters/") and pname.contains("blend_position")
	
	_blend_positions = get_property_list().filter(blend_positions_filter)


func _physics_process(_delta: float) -> void:
	for blend_poition in _blend_positions:
		set(blend_poition.name, character.facing_vector)
	
	is_moving = not character.velocity.length_squared() < 1.


func _on_ability_used(ability: AbilityBase) -> void:
	_playback.travel(ability.name, false)
	
	var try_refresh = func(anim_name):
		if anim_name == ability.name:
			ability.refresh()
	_playback.state_finished.connect(try_refresh)


func _on_die() -> void:
	_playback.travel("idle")
	is_dead = true
