extends Area2D
class_name XpPickup

func _ready() -> void:
	%AnimationPlayer.play("wobble")

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("collect_xp"):
		AudioManager.play_xp_sfx()
		body.collect_xp(1)
		queue_free() # remove the xp node

func _on_expiration_timeout() -> void:
	queue_free() 
