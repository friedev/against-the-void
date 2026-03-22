class_name World extends Node2D

func _ready() -> void:
	SignalBus.game_loaded.connect(_on_game_loaded)
	process_mode = Node.PROCESS_MODE_DISABLED


func _on_game_loaded() -> void:
	SignalBus.node_spawned.connect(_on_node_spawned)
	process_mode = Node.PROCESS_MODE_INHERIT


func _on_node_spawned(node: Node) -> void:
	assert(node.get_parent() == null)
	add_child(node)
