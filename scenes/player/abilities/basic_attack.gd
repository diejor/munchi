extends AbilityBase

@onready var player: CharacterBody2D = owner
@onready var pivot: Node2D = $Pivot

func _ready() -> void:
	super._ready()
	refresh()

func _physics_process(_delta: float) -> void:
	pivot.rotation = snapped(player.facing_vector.angle(), PI * 0.25)
