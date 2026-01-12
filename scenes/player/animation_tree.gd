class_name ArtAnimator
extends AnimationTree

signal attack_entered

var is_moving: bool = false
var is_attacking: bool = false
var facing_vector: Vector2

var playback: AnimationNodeStateMachinePlayback = get("parameters/playback")

func _physics_process(_delta: float) -> void:
	var movement_input: Vector2
	if not playback.get_current_node() == &"Attack":
		movement_input = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down")
		
	if not movement_input.is_zero_approx():
		facing_vector = movement_input
		set("parameters/Idle/blend_position", movement_input)
		set("parameters/Walk/blend_position", movement_input)
		set("parameters/Attack/blend_position", movement_input)
	
	is_moving = not movement_input.is_zero_approx()
	
	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack_entered.emit()
		playback.travel("Attack")
	is_attacking = playback.get_current_node() == &"Attack"
