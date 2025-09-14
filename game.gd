extends Node2D
class_name Game

signal level_fail
signal level_won

# debug: everything unlocked!
#var unlocked_words : Array = [ 'SOUP']
var unlocked_words : Array
var current_word : String

func reset_game():
	unlocked_words = []

func start_level(word : String):
	
	# remove existing mobs:
	for child in get_children():
		if child is Mob or child is XpPickup or child is SoupPickup:
			child.queue_free()	
	
	# populate initial mobs
	for i in range(5):
		spawn_mob()
		
	%CatPlayer.reset_player()
	_on_cat_player_level_up()
	_on_cat_player_xp_earned()
	current_word = word
	%GoalWord.set_word(current_word)

func spawn_mob():
	var new_mob = preload("res://characters/mob/mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	new_mob.mob_defeated.connect(mob_killed)
	add_child(new_mob)

func mob_killed(letter: String):
	print(letter + " defeated")
	%GoalWord.add_letter(letter)
	%Camera2D.apply_random_shake()

func _on_player_health_depleted() -> void:
	level_fail.emit()

func _on_cat_player_level_up() -> void:
	%Label_PlayerLevel.text = "Level " + str(%CatPlayer.level)

func _on_cat_player_xp_earned() -> void:
	%Progress_PlayerXP.value = %CatPlayer.get_xp_progress() * 100.0

func _on_goal_world_word_completed() -> void:
	unlocked_words.append(current_word)
	level_won.emit()
