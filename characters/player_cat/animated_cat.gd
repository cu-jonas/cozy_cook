extends AnimatedSprite2D

var facing_direction := "Front"

func _ready() -> void:
	play("idle_front")

func play_animation( direction: Vector2):

	if direction.length() > 0: # we are moving
		if abs(direction.x) > abs(direction.y):
			facing_direction = "right" if direction.x < 0 else "left"
		else:
			facing_direction = "back" if direction.y < 0 else "front"
		
		play("walking_" + facing_direction)
		
	else: # we are idle
		if facing_direction == "front":
			play("idle_front")
		elif facing_direction == "back":
			play("idle_back")
		elif facing_direction == "left":
			play("idle_left")
		elif facing_direction == "right":
			play("idle_right")
