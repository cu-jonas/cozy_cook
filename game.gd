extends Node2D

func _ready() -> void:
	for i in range(5):
		spawn_mob()


func spawn_mob():
	var new_mob = preload("res://characters/mob/mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)


func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true
