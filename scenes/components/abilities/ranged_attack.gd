extends AbilityBase

@onready var character: CharacterBody2D = owner
@onready var projectile: ProjectileBase = %Projectile

func _ready() -> void:
	super._ready()
	projectile.visible = false


func _on_projectile_used() -> void:
	var to_launch: ProjectileBase = projectile.duplicate()
	owner.owner.owner.add_child(to_launch)
	to_launch.direction = character.facing_vector
	to_launch.process_mode = Node.PROCESS_MODE_INHERIT
	to_launch.visible = true
