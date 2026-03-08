class_name Main extends Node

@export var world_scene: PackedScene

@export_group("Internal Nodes")
@export var noise_sprite: NoiseSprite

var world: World

func _ready() -> void:
	Options.setup()
	

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		restart()
	

func restart() -> void:
	SignalBus.game_loading.emit()
	if world != null:
		SignalBus.node_spawned.disconnect(world._on_node_spawned)
		world.queue_free()
		await world.tree_exited
	world = world_scene.instantiate()
	add_child(world)
	if not noise_sprite.is_texture_updated:
		await noise_sprite.texture_updated
	SignalBus.game_loaded.emit()
	Globals.start_ticks = Time.get_ticks_msec()


func _on_main_menu_play_pressed() -> void:
	restart()
