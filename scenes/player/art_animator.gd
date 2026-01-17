class_name ArtAnimator
extends AnimationTree

@onready var character: CharacterBody2D = owner.owner
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

@onready var combat: CombatComponent = character.get_node_or_null("%CombatComponent")

var is_moving: bool = false
var is_dead: bool = false
var ability_done: bool = false
var _playback: AnimationNodeStateMachinePlayback = get("parameters/playback")

func _ready() -> void:
	active = true
	assert(tree_root is AnimationNodeStateMachine)
	
	if combat:
		combat.ability_used.connect(_on_ability_used)
		combat.die.connect(_on_die)
		for ability in combat.abilities.get_children():
			assert(tree_root.has_node(ability.name))


func _physics_process(_delta: float) -> void:
	set("parameters/idle/blend_position", character.facing_vector)
	set("parameters/walk/blend_position", character.facing_vector)
	set("parameters/dead/blend_position", character.facing_vector)
	for ability in combat.abilities.get_children():
		var ability_name: String = ability.name
		assert(tree_root.has_node(ability_name))
		set("parameters/%s/blend_position" % ability_name, character.facing_vector)
	
	is_moving = not character.velocity.length_squared() < 1.


func _on_ability_used(ability: AbilityBase) -> void:
	_playback.travel(ability.name, false)
	await animated_sprite.animation_finished
	ability.refresh()
	ability_done = true
	await _playback.state_finished
	ability_done = false
	
	# For some reason, even though we left the state, the tree 
	# tries to plays the previous state, for a single frame. So skip it.
	await get_tree().physics_frame 
	
	# Resume because ability animations are single shot
	animated_sprite.play(animated_sprite.autoplay)
	
	

func _on_die() -> void:
	_playback.travel("idle")
	is_dead = true
