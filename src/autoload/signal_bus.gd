extends Node

@warning_ignore_start("unused_signal")
signal node_spawned(node: Node)
signal screen_shake(new_shake: float)
signal game_loading
signal game_loaded
signal game_over
signal option_changed(key: String, value: Variant)