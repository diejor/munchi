@tool
extends BTAction
## Updates the [NavigationAgent2D] target position and returns [code]RUNNING[/code]
## until the agent reaches the destination. [br]
## Note: The Agent must handle its own velocity and movement in _physics_process.

@export var target_pos_var: StringName = &"target_pos"

func _generate_name() -> String:
	return "NavigateTo ➜%s" % [
		LimboUtility.decorate_var(target_pos_var)
	]

func _enter() -> void:
	var nav_agent: NavigationAgent2D = agent.get_node("%NavigationAgent2D")
	
	var target_pos: Vector2 = blackboard.get_var(target_pos_var, Vector2.ZERO)
	nav_agent.target_position = target_pos

func _tick(_delta: float) -> Status:
	var nav_agent: NavigationAgent2D = agent.get_node_or_null("%NavigationAgent2D")
	
	if not is_instance_valid(nav_agent):
		return FAILURE
	
	if nav_agent.is_navigation_finished():
		return SUCCESS
	
	var target_pos: Vector2 = blackboard.get_var(target_pos_var, Vector2.ZERO)
	nav_agent.target_position = target_pos
		
	return RUNNING
