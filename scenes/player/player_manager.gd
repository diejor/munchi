extends Node

var player: CharacterPlayer:
	get: return get_tree().get_nodes_in_group("player")[0]
