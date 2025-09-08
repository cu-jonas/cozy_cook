extends Area2D

func _ready() -> void:
	%AnimationPlayer.play("wobble")

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("collect_xp"):
		AudioManager.play_sfx("CollectXP")
		body.collect_xp(1)
		queue_free() # remove the xp node
