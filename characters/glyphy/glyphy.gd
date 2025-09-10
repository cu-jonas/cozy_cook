extends Node2D

var letter : String

func _ready() -> void:
	letter = char(randi_range(65, 90))  # ASCII codes 65-90 inclusive
	%Label.text = letter

func play_walk():
	%AnimationPlayer.play("wobble_walk")

func play_hurt():
	%AnimationPlayer.play("hurt")
	%AnimationPlayer.queue("wobble_walk")
