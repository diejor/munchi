extends CharacterBody2D

@export var speed: float = 50.

@onready var player_art: Node2D = %PlayerArt
@onready var art_animator: ArtAnimator = player_art.get_node("%AnimationTree")


func _physics_process(_delta: float) -> void:
	var input: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input * speed
	art_animator.on_update(input)
	move_and_slide()
