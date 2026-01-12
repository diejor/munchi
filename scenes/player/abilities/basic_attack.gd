extends AbilityBase

@onready var player_art: Node2D = owner.get_node("%PlayerArt")
@onready var art_animator: ArtAnimator = player_art.get_node("%AnimationTree")
@onready var pivot: Node2D = $Pivot

func _ready() -> void:
	super._ready()

func _physics_process(_delta: float) -> void:
	pivot.rotation = art_animator.facing_vector.angle()
