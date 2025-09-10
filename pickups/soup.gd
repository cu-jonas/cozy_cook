extends Area2D
class_name SoupPickup

func _ready() -> void:
	%AnimationPlayer.play("wobble")

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("collect_soup"):
		AudioManager.play_xp_sfx()
		body.collect_soup(5)
		queue_free() # remove the xp node

func _on_expiration_timeout() -> void:
	queue_free() 
