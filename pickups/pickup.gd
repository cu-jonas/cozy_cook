extends Area2D
class_name Pickup

@export var pickup_type := "xp" 
@export var pickup_value := 1
@export var pickup_sound := "CollectXP"

func _ready() -> void:
	%AnimationPlayer.play("wobble")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		pass
		
	if body.has_method("collect_pickup"):
		AudioManager.play_xp_sfx()
		body.collect_pickup(pickup_type,pickup_value)
		queue_free() # remove the xp node

func _on_expiration_timeout() -> void:
	queue_free() 
