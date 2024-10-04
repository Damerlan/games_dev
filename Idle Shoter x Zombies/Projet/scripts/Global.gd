extends Node

var coins = 0
var zombies_killed = 0
var zombies_killed_int = 0 # Zumbis mortos no turno atual

func increment_global_zombie_kill():
	zombies_killed += 1
	
func _ready():
	pass
