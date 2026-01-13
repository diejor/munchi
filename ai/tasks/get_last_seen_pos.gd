#* task_get_last_seen_pos.gd
@tool
extends BTAction
## Calculates the global position of the target from the [SightComponent] and stores it 
## in the blackboard.
## Returns [code]SUCCESS[/code] immediately.


## Blackboard variable to store the position (Vector2).
@export var target_pos_var: StringName = &"target_pos"

var _sight: SightComponent

func _generate_name() -> String:
	return "Get last seen pos -> %s" % LimboUtility.decorate_var(target_pos_var)

func _setup() -> void:
	_sight = agent.get_node("%SightComponent")

func _tick(_delta: float) -> Status:
	if not is_instance_valid(_sight):
		return FAILURE
	
	blackboard.set_var(target_pos_var, _sight.last_seen)
	return SUCCESS
