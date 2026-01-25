extends AbilityBase

@onready var pivot: Node2D = $Pivot

func _physics_process(_delta: float) -> void:
	pivot.rotation = snapped(character.facing_vector.angle(), PI * 0.25)
	
