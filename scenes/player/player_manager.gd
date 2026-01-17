extends Node

var player: CharacterPlayer:
	get:
		var p = get_tree().get_nodes_in_group("player")
		if not p.is_empty():
			return p[0]
		return null
