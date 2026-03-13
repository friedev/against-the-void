extends Control

var current_action_icon: ActionIcon

func _on_action_icon_gui_input(event: InputEvent, source: Control) -> void:
	if event.is_action_pressed("ui_select") or (
		event is InputEventMouseButton
		and (event as InputEventMouseButton).is_pressed()
		and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT
	):
		current_action_icon = source


func _input(event: InputEvent) -> void:
	if current_action_icon:
		var action := current_action_icon.action_name
		if event is InputEventKey:
			Options.controls_remap.set_action_key(action, event as InputEventKey)
		elif event is InputEventJoypadButton:
			Options.controls_remap.set_action_button(action, event as InputEventJoypadButton)
		else:
			return
		current_action_icon.refresh()
		current_action_icon = null