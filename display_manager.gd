extends Node

# Base resolution to compare against
const BASE_WIDTH  := 1920.0
const BASE_HEIGHT := 1080.0

# Signal for UI elements that want to react
signal resolution_changed(new_size: Vector2, is_portrait: bool)

func _ready() -> void:
	# Connect to screen resize events
	get_tree().root.size_changed.connect(_on_window_resized)
	_on_window_resized() # run once at startup

func _on_window_resized() -> void:
	var size = get_window().size
	var is_portrait = size.y > size.x
	
	# Compare both axes against your design baseline
	var scale_x = size.x / BASE_WIDTH
	var scale_y = size.y / BASE_HEIGHT

	# Pick the smaller one (limiting axis)
	var scale = min(scale_x, scale_y)
	# Apply global scale so visuals stay "large"
	get_viewport().set_content_scale_factor(1.0/scale)

	print("New scale " + str(scale))

	# Store globally if you like
	ProjectSettings.set_setting("ui/custom_scale", scale)

	# Emit so UI nodes can react
	emit_signal("resolution_changed", size, is_portrait)
