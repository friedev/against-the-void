class_name EnemySpawner extends Node2D

@export var flip_h: bool
## The minimum distance above the void that enemies can spawn at.
@export var min_void_distance: float

func spawn(enemy: Enemy) -> void:
	enemy.global_position = Vector2(global_position.x, lerpf(Void.instance.global_position.y - min_void_distance, global_position.y, randf()))
	if flip_h:
		enemy.scale.x *= -1.0
	SignalBus.node_spawned.emit(enemy)