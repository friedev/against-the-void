class_name EnemySpawner extends Node2D

@export var flip_h: bool

func spawn(enemy: Enemy) -> void:
	enemy.global_position = Vector2(global_position.x, lerpf(0.0, global_position.y, randf()))
	if flip_h:
		enemy.scale.x *= -1.0
	SignalBus.node_spawned.emit(enemy)