class_name CharacterNPC
extends CharacterBodyBase


const iSQRT2 = 0.70710678118

@onready var navigation_agent: NavigationAgent2D = %NavigationAgent2D
@onready var wander_area: WanderArea = %WanderArea

var facing_vector: Vector2

func _ready() -> void:
	super._ready()
	assert(mass > 0, "Damping must be positive to prevent freezing")

	if not navigation_agent.velocity_computed.is_connected(_on_velocity_computed):
		navigation_agent.velocity_computed.connect(_on_velocity_computed)


func set_movement_target(movement_target: Vector2) -> void:
	navigation_agent.set_target_position(movement_target)


func _physics_process(_delta: float) -> void:
	if NavigationServer2D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return

	if navigation_agent.is_navigation_finished() or navigation_agent.target_position == Vector2.ZERO:
		_on_velocity_computed(Vector2.ZERO)
		return

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var desired_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_speed
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(desired_velocity)
	else:
		_on_velocity_computed(desired_velocity)


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	move_with_velocity(safe_velocity)
