class_name Main extends Node2D

func _ready() -> void:
	SignalBus.node_spawned.connect(_on_node_spawned)
	process_mode = Node.PROCESS_MODE_DISABLED
	hide()
	

func _on_node_spawned(node: Node) -> void:
	add_child(node)
	

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		restart()
	

func restart() -> void:
	# Disconnect node_spawned signal before reloading scene. Otherwise,
	# SmartSounds and SmartParticles try to reparent themselves to Main via
	# node_spawned while the current tree is being unloaded, causing errors
	# ("Parent node is busy setting up children, `add_child()` failed.").
	SignalBus.node_spawned.disconnect(_on_node_spawned)
	get_tree().reload_current_scene()


func _on_noise_sprite_texture_updated() -> void:
	show()
	process_mode = Node.PROCESS_MODE_INHERIT
