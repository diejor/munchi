extends AbilityBase

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

func _ready() -> void:
	collision_shape_2d.scale *= 3.

func delete() -> void:
	owner.queue_free.call_deferred()

func hide() -> void:
	owner.visible = false
	owner.process_mode = Node.PROCESS_MODE_DISABLED
