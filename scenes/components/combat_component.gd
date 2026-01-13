class_name CombatComponent
extends Node

signal damage_taken
signal heart_restored

@export var abilities: Dictionary[StringName, AbilityBase]
@export var health: int
@export var knockback_force: float = 100.


@onready var damage_cooldown: Timer = $DamageCooldown

func _ready() -> void:
	unique_name_in_owner = true

func _physics_process(_delta: float) -> void:
	for action in abilities.keys():
		if Input.is_action_just_pressed(action):
			abilities[action].try_use()


func take_damage(attacker: CombatComponent) -> void:
	var attacker_pos: Vector2 = attacker.owner.global_position
	var pos: Vector2 = owner.global_position
	var knockback_dir: Vector2 = -pos.direction_to(attacker_pos)
	owner.velocity = knockback_dir * attacker.knockback_force
	damage_taken.emit()
	
	owner.modulate = Color.from_hsv(0., 0., 1000.)
	damage_cooldown.start()
	
func restore_health() -> void:
	heart_restored.emit()


func _on_timer_timeout() -> void:
	owner.modulate = Color.WHITE
