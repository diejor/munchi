#* in_sight.gd
@tool
extends BTCondition
## Checks if the agent has a line of sight to the tracked node using the [SightComponent].
## Returns [code]SUCCESS[/code] if [member SightComponent.in_los] is true.

var _sight: SightComponent

func _generate_name() -> String:
	return "Can see tracked node?"

func _setup() -> void:
	_sight = agent.get_node("%SightComponent")

func _tick(_delta: float) -> Status:
	if not is_instance_valid(_sight):
		return FAILURE
		
	if _sight.in_los:
		return SUCCESS
	
	return FAILURE
