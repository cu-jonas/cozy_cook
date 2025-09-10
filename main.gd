extends Node

var level_index = 0
var words : Array = [ 'SOUP', 'CARROT', 'PUMPKIN']


func _ready() -> void:
	Globals.CatGame = %Game
	_start_level()
	
func _on_next_level_button_pressed() -> void:
	_start_level()

func _on_restart_game_button_pressed() -> void:
	level_index = 0
	%Game.reset_game()
	_start_level()

func _on_retry_level_button_pressed() -> void:
	_start_level()

func _start_level():
	print('level started')
	%Game.get_tree().paused = false
	%Game.start_level(words[level_index])
	%LevelComplete.visible = false
	%GameOver.visible = false
	%GameWon.visible = false
	

func _on_game_level_fail() -> void:
	%Game.get_tree().paused = true
	%GameOver.visible = true


func _on_game_level_won() -> void:
	%Game.get_tree().paused = true
	
	# this is a really bad way to do this, but it works!
	%SoupImage.visible = false
	%PumpkinImage.visible = false
	%CarrotImage.visible = false
	
	if level_index == 0:
		%SoupImage.visible = true
	elif level_index == 1:
		%CarrotImage.visible = true
	elif level_index == 2:
		%PumpkinImage.visible = true
	
	level_index += 1
	
	if level_index < words.size():
		%LevelComplete.visible = true
	else:
		%GameWon.visible = true
		
	
