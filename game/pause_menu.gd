extends CanvasLayer

@onready var pause_menu = %PauseControl  # your Control node inside the CanvasLayer

signal game_paused
signal game_resumed
signal game_quit

func _ready() -> void:
	pause_menu.visible = false
	game_resumed.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):  # Escape by default
		_toggle_pause()

func _toggle_pause() -> void:
	var tree = get_tree()
	if not tree.paused:
		game_paused.emit()
	tree.paused = not tree.paused
	pause_menu.visible = tree.paused
	if not tree.paused:
		game_resumed.emit()
	
	
func _on_resume_button_pressed() -> void:
	_toggle_pause()


func _on_quit_button_pressed() -> void:
	_toggle_pause()
	game_quit.emit()
