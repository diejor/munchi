extends AbilityBase

@onready var player: CharacterBody2D = owner
@onready var pivot: Node2D = $Pivot

func _ready() -> void:
	super._ready()

func _physics_process(_delta: float) -> void:
	pivot.rotation = player.facing_vector.angle()
