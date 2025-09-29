extends Node

const BASE_WIDTH  := 1920.0
const BASE_HEIGHT := 1080.0

signal resolution_changed(new_size: Vector2, is_portrait: bool)

func _ready() -> void:
	get_tree().root.size_changed.connect(_on_window_resized)
	_on_window_resized() # run once at startup

func _on_window_resized() -> void:
	var size = get_window().size
	var is_portrait = size.y > size.x
	var scale_x = size.x / BASE_WIDTH
	var scale_y = size.y / BASE_HEIGHT
	var scale = min(scale_x, scale_y)
	get_viewport().set_content_scale_factor(1.0/scale)
	ProjectSettings.set_setting("ui/custom_scale", scale)
	emit_signal("resolution_changed", size, is_portrait)
