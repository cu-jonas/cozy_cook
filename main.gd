extends Node

func _ready() -> void:
	%GameWon.visible = false
	%GameOver.visible = false

func _on_game_game_over() -> void:
	%Game.get_tree().paused = true
	%GameOver.visible = true

func _on_game_game_won() -> void:
	%Game.get_tree().paused = true
	%GameWon.visible = true


func _on_next_level_button_pressed() -> void:
	print('next level started')
	%Game.get_tree().paused = false
	%Game.start_game()
	%GameWon.visible = false
	
