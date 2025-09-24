extends CharacterBody2D
class_name Mob

@onready var player = get_node("/root/Main/Game/CatPlayer")
@export var GlyphyLetter := "0"
@export var health = 100

signal mob_defeated

func _ready():
	%Glyphy.play_walk()
	
	if GlyphyLetter != "0":
		set_letter(GlyphyLetter)
	
	print('spawning mob')
	

func _init() -> void:
	# register the defeated with the game
	mob_defeated.connect(Globals.CatGame.mob_killed)



func set_letter(letter: String):
	%Glyphy.set_letter(letter)

func _physics_process(_delta: float):
	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * 150.0
		move_and_slide()

func take_damage(damage: float):
	health -= damage
	
	%Glyphy.play_hurt()
	#AudioManager.play_sfx("EnemyHit", 0, true)
	
	if health <= 0:
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
	const SMOKE_SCENE = preload("res://effects/smoke_explosion/smoke_explosion.tscn")
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
