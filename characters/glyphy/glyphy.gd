extends Node2D
class_name Glyphy

var letter : String

func _ready() -> void:
	#set_letter(char(randi_range(65, 90)))  # ASCII codes 65-90 inclusive
	pass
	
func set_letter(new_letter: String):
	letter = new_letter
	%Label.text = letter

func play_walk():
	%AnimationPlayer.play("wobble_walk")

func play_hurt():
	%AnimationPlayer.play("hurt")
	%AnimationPlayer.queue("wobble_walk")
