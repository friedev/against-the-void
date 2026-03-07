class_name Main extends Node2D

func _ready() -> void:
	SignalBus.node_spawned.connect(_on_node_spawned)
	

func _on_node_spawned(node: Node) -> void:
	add_child(node)