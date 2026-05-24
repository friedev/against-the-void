class_name FullscreenOption
extends CheckBoxOption

var previous_value: bool


func _ready() -> void:
	# Source the default value from Project Settings (allows custom settings
	# for web, editor, etc.)
	default = get_option()
	super._ready()
	previous_value = default


func get_option() -> bool:
	return _is_fullscreen(get_window().mode)


func set_option(value: Variant) -> bool:
	if super.set_option(value):
		var window := get_window()
		if value:
			if not _is_fullscreen(window.mode):
				window.mode = Window.MODE_FULLSCREEN
		else:
			if _is_fullscreen(window.mode):
				window.mode = Window.MODE_WINDOWED
		return true
	return false


func _is_fullscreen(mode: Window.Mode) -> bool:
	return (
		mode == Window.MODE_FULLSCREEN
		or mode == Window.MODE_EXCLUSIVE_FULLSCREEN
	)


func _process(_delta: float) -> void:
	# Ideally this would trigger via a signal or notification, but I can't find
	# one that deals with window mode changes
	# Tried:
	# - NOTIFICATION_WM_SIZE_CHANGED
	# - Window.titlebar_changed
	# - Viewport.size_changed
	var current_value := get_option()
	if current_value != previous_value:
		previous_value = current_value
		set_option(current_value)
