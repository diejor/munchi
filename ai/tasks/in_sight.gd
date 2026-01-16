@tool
extends BTCondition

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
