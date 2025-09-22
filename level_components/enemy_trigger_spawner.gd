extends Node2D


func _on_event_trigger_body_entered(body: Node2D) -> void:
	if body is Player:
		print ('player hit trigger!')
		%Timer.start()

func _on_event_trigger_body_exited(body: Node2D) -> void:
	if body is Player:
		print ('player left trigger!')
		%Timer.stop()

func _on_timer_timeout() -> void:
	_spawn_mob()

func _spawn_mob():
	var new_mob = preload("res://characters/mob/mob.tscn").instantiate()
	new_mob.global_position = %SpawnPoint.global_position
	Globals.CatGame.add_child(new_mob)
