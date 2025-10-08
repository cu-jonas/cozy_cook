extends Node

var active_music: AudioStreamPlayer
var active_sfx : AudioStreamPlayer

func _ready():
	play_music("Main")

func play_music(clip_name: String, position: float = 0):
	if active_music and active_music.playing:
		active_music.stop()
	active_music = %Music.get_node(clip_name)
	active_music.play(position)

func play_sfx(clip_name: String, position: float = 0, playMultiple: bool = false):
	active_sfx = %Sfx.get_node(clip_name)
	if !active_sfx.playing or playMultiple:
		active_sfx.play(position)
	
	
var xp_index := 0	
var pitch_array := [ .8, .9, 1, 1.2, 1.3]
func play_xp_sfx():
	active_sfx = %Sfx.get_node("CollectXP")
	active_sfx.play()
	active_sfx.pitch_scale = pitch_array[xp_index]
	xp_index += 1
	if xp_index >= pitch_array.size():
		xp_index = 0
	
func button_click():
	active_sfx = %Sfx.get_node("ButtonClick")
	active_sfx.play()
	active_sfx.pitch_scale = pitch_array[randi() % 5]



# Converts linear 0–1 to decibels internally
func _linear_to_db(linear: float) -> float:
	if linear == 0.0: 
		return -80.0 
	else: 
		return 0.0 * log(linear)/log(10.0)

# Converts decibels to linear 0–1
func _db_to_linear(db: float) -> float:
	return pow(10.0, db / 20.0)

# Set bus volume (linear)
func set_bus_volume(bus_name: String, value: float) -> void:
	value = clamp(value, 0.0, 1.0)
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		push_warning("Bus '%s' not found." % bus_name)
		return
	AudioServer.set_bus_volume_db(bus_index, _linear_to_db(value))

# Get bus volume (returns linear 0–1)
func get_bus_volume(bus_name: String) -> float:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		push_warning("Bus '%s' not found." % bus_name)
		return 0.0
	var db = AudioServer.get_bus_volume_db(bus_index)
	return _db_to_linear(db)
