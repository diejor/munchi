extends CharacterBody2D

@export var speed: float = 50.

@onready var combat: CombatComponent = %CombatComponent

var facing_vector: Vector2

func _ready() -> void:
	visibility_changed.emit()

func _physics_process(_delta: float) -> void:
	var input: Vector2
	if not combat.is_using_ability():
		input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
	if not input.is_zero_approx():
		facing_vector = input
	
	velocity = input * speed
	move_and_slide()
