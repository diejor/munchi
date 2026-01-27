extends Hitbox


var active: bool = monitoring

func _ready() -> void:
	super._ready()
	active = monitoring

func flip() -> void:
	active = not active
	if active:
		fire()
	else:
		cool()
