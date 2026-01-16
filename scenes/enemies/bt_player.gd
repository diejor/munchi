extends BTPlayer

@onready var combat: CombatNPC = %CombatComponent

func _ready() -> void:
	unique_name_in_owner = true
	combat.die.connect(_on_die)
	
	
func _on_die() -> void:
	active = false
