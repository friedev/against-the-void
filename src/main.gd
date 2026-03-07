class_name Main extends Node2D

func _ready() -> void:
	SignalBus.node_spawned.connect(_on_node_spawned)
	

func _on_node_spawned(node: Node) -> void:
	add_child(node)
	

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		restart()
	

func restart() -> void:
	get_tree().reload_current_scene()