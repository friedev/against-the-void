class_name Main extends Node

@export var world_scene: PackedScene

@export_group("Internal Nodes")
@export var parallax_nodes: Array[Parallax2D]
@export var temp_camera: Camera2D

var world: World

func _ready() -> void:
	Options.setup()
	randomize_parallax()
	

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		restart()
	

func restart() -> void:
	SignalBus.game_loading.emit()
	temp_camera.enabled = false
	if world != null:
		SignalBus.node_spawned.disconnect(world._on_node_spawned)
		world.queue_free()
		await world.tree_exited
	randomize_parallax()
	world = world_scene.instantiate()
	add_child(world)
	SignalBus.game_loaded.emit()
	Globals.start_ticks = Time.get_ticks_msec()


func randomize_parallax() -> void:
	for parallax in parallax_nodes:
		parallax.scroll_offset = parallax.repeat_size * Vector2(randf(), randf())


func _on_main_menu_play_pressed() -> void:
	restart()
