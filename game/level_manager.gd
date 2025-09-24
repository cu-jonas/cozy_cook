extends Node2D

var current_level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func load_level(scene: PackedScene):
	var level_instance = scene.instantiate()
	current_level = level_instance
	add_child(level_instance)
	await get_tree().process_frame

func get_player_spawn_location():
	
	for c in current_level.get_children(true):
		print(c.name)
		
	var spawn = current_level.find_children("PlayerSpawn").front() as Node2D
	return spawn.global_position
	 
	
