class_name CombatComponent
extends Node

@warning_ignore("unused_signal")
signal ability_used(ability: AbilityBase)

signal die
signal damage_taken(points: int)
signal heart_restored(points: int)

@export var health: int
@export var knockback_force: float = 100.

var abilities: Node2D:
	get: return $Abilities

@onready var health_bar: ProgressBar = %HealthBar
@onready var damage_particles_1: GPUParticles2D = $DamageParticles1
@onready var damage_particles_2: GPUParticles2D = $DamageParticles2
@onready var damage_cooldown: Timer = $DamageCooldown
@onready var initial_health: int = health


var current_ability: AbilityBase
var facing_vector: Vector2

func _enter_tree() -> void:
	unique_name_in_owner = true


func consume_ability(used: AbilityBase) -> void:
	current_ability = null
	used.refreshed.disconnect(consume_ability)

func take_damage(attacker: CombatComponent, ability: AbilityBase) -> void:
	var attacker_pos: Vector2 = attacker.owner.global_position
	var pos: Vector2 = owner.global_position
	var knockback_dir: Vector2 = -pos.direction_to(attacker_pos)
	owner.velocity = knockback_dir * attacker.knockback_force
	damage_taken.emit(ability.damage)
	
	owner.modulate = Color.from_hsv(0., 0., 1000.)
	
	var knock_vec3: Vector3 = Vector3(knockback_dir.x, knockback_dir.y, 0.0)
	damage_particles_1.process_material.direction = knock_vec3
	damage_particles_2.process_material.direction = knock_vec3
	if not damage_particles_1.emitting:
		damage_particles_1.emitting = true
		damage_particles_2.restart()
	elif not damage_particles_2.emitting:
		damage_particles_2.emitting = true
		damage_particles_1.restart()
	
	damage_cooldown.start()
	
func restore_health() -> void:
	heart_restored.emit()


func is_using_ability() -> bool:
	return current_ability != null


func _on_timer_timeout() -> void:
	owner.modulate = Color.WHITE


func _on_damage_taken(points: int) -> void:
	health -= points
	if health <= 0:
		owner.queue_free.call_deferred()
		die.emit()
	
	health_bar.value = (health as float / initial_health) * 100.

func get_ability(ability: String) -> void:
	return get_node(ability)
