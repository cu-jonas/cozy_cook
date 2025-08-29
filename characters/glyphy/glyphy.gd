extends Node2D

func _ready() -> void:
	%Label.text = char(randi_range(65, 90))  # ASCII codes 65-90 inclusive

func play_walk():
	%AnimationPlayer.play("wobble_walk")


func play_hurt():
	%AnimationPlayer.play("hurt")
	%AnimationPlayer.queue("wobble_walk")
