extends CharacterBody2D

class_name Player

var health = 100.0
var xp = 0
var level = 1
var xp_requirements: Array = [
	3,5,10,15
]

var weapon_dps: Array = [
	100, 150, 200, 250, 300, 350
]

var character_scale: Array = [ 1.0, 1.2, 1.35, 1.45, 1.5, 1.55]

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
	
	
func collect_pickup(pickup_type:String, pickup_value:int):
	if pickup_type == "xp":
		xp+=pickup_value
		_check_level_up()
		# run this after the level up so it goes down!
		xp_earned.emit()
	elif pickup_type == "health":
		# heal the player
		health = clamp(health + pickup_value, 0, 100)
		%HealthBar.value = health
	


func _check_level_up():
	while level - 1 < xp_requirements.size() and xp >= xp_requirements[level - 1]:
		xp -= xp_requirements[level - 1] # subtract spent XP (optional)
		level += 1
		print("Level up! Now level ", level)
		level_up.emit()
	
	
func _on_level_up() -> void:
		AudioManager.play_sfx("PlayerLevelUp", 0, true)
		scale = Vector2.ONE * character_scale[level - 1]
		%Laser.set_laser_damage(weapon_dps[level - 1])

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
	if weapon_dps.size() > 0:
		%Laser.set_laser_damage(weapon_dps[level - 1])
	
	# Reset XP bar (emit so UI updates if bound)
	xp_earned.emit()
