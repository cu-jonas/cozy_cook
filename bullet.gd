extends Area2D

var travelled_distance = 0

func _physics_process(delta: float):
	
	const SPEED = 50
	const RANGE = 50
	
	var direction = Vector2.RIGHT.rotated(rotation)
	
	travelled_distance += SPEED * delta
	global_position += direction * travelled_distance
	
	if travelled_distance > RANGE:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
	
