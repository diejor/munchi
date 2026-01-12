extends CharacterBody2D

@export var speed: float = 50.

@onready var player_art: Node2D = %PlayerArt
@onready var art_animator: ArtAnimator = player_art.get_node("%AnimationTree")

func _ready() -> void:
	visibility_changed.emit()

func _physics_process(_delta: float) -> void:
	var input: Vector2
	if not art_animator.is_attacking:
		input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = input * speed
	move_and_slide()
