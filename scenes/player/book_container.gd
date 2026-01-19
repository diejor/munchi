extends TabContainer

var no_pixel: bool = false

func _ready() -> void:
	visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("book"):
		visible = not visible
