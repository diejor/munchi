@tool
extends BTAction
## Generates a random wander point using the agent's [code]%WanderArea[/code] node
## and stores it in the blackboard. Returns [code]SUCCESS[/code]. [br]
## Returns [code]FAILURE[/code] if the %WanderArea node cannot be found.

## Blackboard variable in which the task will store the target Vector2.
@export var output_var: StringName = &"target_pos"

func _generate_name() -> String:
	return "GetWanderPoint ➜%s" % [
		LimboUtility.decorate_var(output_var)
	]

func _tick(_delta: float) -> Status:
	# We attempt to find the node using the unique name syntax relative to the agent.
	var wander_area: WanderArea = agent.get_node_or_null("%WanderArea")
	
	if not wander_area:
		push_warning("GetWanderPoint: Agent '%s' does not have a unique child node '%%WanderArea'" % agent.name)
		return FAILURE

	var point: Vector2 = wander_area.get_wander_point()
	blackboard.set_var(output_var, point)
	
	return SUCCESS
