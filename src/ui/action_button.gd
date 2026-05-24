@tool
class_name ActionButton
extends Control

@export var text: String
@export var action: String

@export_group("Internal Nodes")
@export var icon: ActionIcon
@export var label: Label
@export var button: Button

var listening: bool:
	set(value):
		listening = value
		button.button_pressed = listening
		var content_modulate := Color.BLACK if listening else Color.WHITE
		label.modulate = content_modulate
		icon.modulate = content_modulate


func _ready() -> void:
	refresh()
	set_process(Engine.is_editor_hint())


func _process(_delta: float) -> void:
	refresh()


func refresh() -> void:
	icon.action_name = action
	label.text = text


func _input(event: InputEvent) -> void:
	if not Engine.is_editor_hint() and listening:
		if event is InputEventKey:
			Options.controls_remap.set_action_key(action, event as InputEventKey)
		elif event is InputEventJoypadButton:
			Options.controls_remap.set_action_button(action, event as InputEventJoypadButton)
		elif event is InputEventMouseMotion:
			return
		else:
			listening = false
			return
		listening = false
		icon.refresh()
		get_viewport().set_input_as_handled()


func _on_button_toggled(toggled_on: bool) -> void:
	if not Engine.is_editor_hint():
		listening = toggled_on
