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
	
