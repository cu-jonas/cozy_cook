extends CharacterBody2D
class_name Mob

@onready var player = get_node("/root/Main/Game/CatPlayer")

var health = 3

signal mob_defeated

func _ready():
	%Glyphy.play_walk()

func _physics_process(_delta: float):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 150.0
	move_and_slide()

func take_damage():
	health -= 1
	
	%Glyphy.play_hurt()
	AudioManager.play_sfx("EnemyHit", 0, true)
	
	if health == 0:
		call_deferred("_die")

func _die():
	
	if randf() < .2 and Globals.CatGame.unlocked_words.has("SOUP"):
		_spawn_soup()	
	else:
		_spawn_crystal()
		
	_spawn_smoke()
	AudioManager.play_sfx("EnemyDie", 0, true)
	mob_defeated.emit(%Glyphy.letter)
	
	queue_free()
	
	
func _spawn_smoke():
	const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
	var smoke = SMOKE_SCENE.instantiate()
	get_parent().add_child(smoke)
	smoke.global_position = global_position

func _spawn_crystal():
	const XP_CRYSTAL = preload("res://pickups/xp.tscn")
	var xp = XP_CRYSTAL.instantiate()
	get_parent().add_child(xp)
	xp.global_position = global_position

func _spawn_soup():
	const SOUP = preload("res://pickups/soup.tscn")
	var soup = SOUP.instantiate()
	get_parent().add_child(soup)
	soup.global_position = global_position
