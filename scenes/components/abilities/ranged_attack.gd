extends AbilityBase


@onready var sight: SightComponent:
		get: return character.get_node("%SightComponent")
@onready var projectile: ProjectileBase = %Projectile


func _ready() -> void:
	super._ready()
	projectile.visible = false


func _on_projectile_used() -> void:
	var to_launch: ProjectileBase = projectile.duplicate()
	to_launch.position = owner.global_position + projectile.position
	to_launch.direction = sight.target_direction
	to_launch.process_mode = Node.PROCESS_MODE_INHERIT
	to_launch.visible = true
	to_launch.hitbox.ability = self
	to_launch.tree_entered.connect(to_launch.set.bind("owner", self))
	add_child(to_launch)
	
