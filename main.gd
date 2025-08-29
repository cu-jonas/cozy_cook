extends Node





func _on_game_game_over() -> void:
	%Game.get_tree().paused = true
	%GameOver.visible = true
