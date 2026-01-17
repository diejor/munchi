extends PanelContainer

@onready var container: Control = %Container
@onready var hearts: Array = container.get_children()

@onready var player: Node = owner
@onready var combat: CombatComponent = player.get_node("%CombatComponent")

var no_pixel: bool = false

func _ready() -> void:
	unique_name_in_owner = true
	combat.damage_taken.connect(_on_damage_taken)
	hearts.reverse()

func _on_damage_taken(points: int) -> void:
	for heart in hearts:
		if heart.visible:
			heart.visible = false
			points = points - 1
			if points == 0:
				break
