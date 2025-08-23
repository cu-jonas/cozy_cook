extends CharacterBody2D

var health = 100.0

signal health_depleted


func _physics_process(delta: float):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()
	
	%AnimatedCat.play_animation(velocity)

	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	const DAMAGE_RATE = 50.0
	health -= overlapping_mobs.size() * DAMAGE_RATE * delta
	
	if overlapping_mobs.size() > 0:
		%AnimationPlayer.play("hit_flash")
		if not %AudioHitSound.playing:
			%AudioHitSound.play()


	%HealthBar.value = health
	if health <= 0.0:
		if not %AudioDeathSound.playing:
			%AudioDeathSound.play()
		health_depleted.emit()
	
