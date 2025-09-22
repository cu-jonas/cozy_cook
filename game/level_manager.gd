extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func get_player_spawn_location():
	var spawn = find_children("PlayerSpawn").front() as Node2D
	return spawn.global_position
	 
