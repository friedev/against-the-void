class_name EnemySpawner extends Node2D

@export var enemy_scene: PackedScene

func _on_spawn_timer_timeout() -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.global_position = global_position
	SignalBus.node_spawned.emit(enemy)
