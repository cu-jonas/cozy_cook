extends Node

var active_music: AudioStreamPlayer
var active_sfx : AudioStreamPlayer

func _ready():
	play_music("Main")

func play_music(clip_name: String, position: float = 0):
	active_music = %Music.get_node(clip_name)
	active_music.play(position)

func play_sfx(clip_name: String, position: float = 0):
	active_sfx = %Sfx.get_node(clip_name)
	if !active_sfx.playing:
		active_sfx.play(position)
	
	
