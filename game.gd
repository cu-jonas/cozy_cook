extends Node2D

signal game_over
signal game_won

var goal_words : Array = [ 'CAT' ]
var goal_word_index = 0

func _ready() -> void:
	for i in range(5):
		spawn_mob()
		
	# set the first word
	%GoalWord.set_word(goal_words[0])

func spawn_mob():
	var new_mob = preload("res://characters/mob/mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	new_mob.mob_defeated.connect(mob_killed)
	add_child(new_mob)

func mob_killed(letter: String):
	print(letter + " defeated")
	%GoalWord.add_letter(letter)

func _on_player_health_depleted() -> void:
	game_over.emit()

func _on_cat_player_level_up() -> void:
	%Label_PlayerLevel.text = "Level " + str(%CatPlayer.level)

func _on_cat_player_xp_earned() -> void:
	%Progress_PlayerXP.value = %CatPlayer.get_xp_progress() * 100.0

func _on_goal_world_word_completed() -> void:
	goal_word_index += 1
	if goal_word_index >= goal_words.size():
		game_won.emit()
	else:
		%GoalWord.set_word(goal_words[goal_word_index])
