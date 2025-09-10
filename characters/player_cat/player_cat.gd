extends CharacterBody2D

var health = 100.0
var xp = 0
var level = 1
var xp_requirements: Array = [
	3,5,10,15
]

var weapon_speed: Array = [
	.5, .4, .3, .2, .1, .05
]

signal health_depleted
signal level_up
signal xp_earned

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
		AudioManager.play_sfx("PlayerHurt")


	%HealthBar.value = health
	if health <= 0.0:
		AudioManager.play_sfx("PlayerDeath")
		health_depleted.emit()
	
	
func collect_xp(amount: int):
	xp+=amount
	_check_level_up()
	# run this after the level up so it goes down!
	xp_earned.emit()
	
func _check_level_up():
	while level - 1 < xp_requirements.size() and xp >= xp_requirements[level - 1]:
		xp -= xp_requirements[level - 1] # subtract spent XP (optional)
		level += 1
		print("Level up! Now level ", level)
		level_up.emit()
	
	
func _on_level_up() -> void:
		AudioManager.play_sfx("PlayerLevelUp", 0, true)
		scale = Vector2.ONE * (1.0 + (float(level) / 5.0))
		%Weapon.set_weapon_cooldown(weapon_speed[level])

func get_xp_progress() -> float:
	if level - 1 >= xp_requirements.size():
		# Already at or above max level
		return 1.0
	
	var required_xp = xp_requirements[level - 1]
	var progress = float(xp) / float(required_xp)
	return clamp(progress, 0.0, 1.0)

func reset_player():
	# Reset stats
	health = 100.0
	xp = 0
	level = 1
	
	# Reset visuals
	scale = Vector2.ONE
	%AnimatedCat.play_animation(Vector2.ZERO) # idle animation
	%AnimationPlayer.stop(true) # stop flashing animations
	%HealthBar.value = health
	
	# Reset weapon cooldown
	if weapon_speed.size() > 0:
		%Weapon.set_weapon_cooldown(weapon_speed[0])
	
	# Reset XP bar (emit so UI updates if bound)
	xp_earned.emit()
