class_name EnemySpawner extends Node2D

@export var flip_h: bool
@export var enemy_scene: PackedScene
@export var spawn_time: float

@export_group("Internal Nodes")
@export var spawn_timer: Timer

func _ready() -> void:
	spawn_timer.wait_time = spawn_time
	spawn_timer.start()


func _on_spawn_timer_timeout() -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.global_position = Vector2(global_position.x, lerpf(0.0, global_position.y, randf()))
	if flip_h:
		enemy.scale.x *= -1.0
	SignalBus.node_spawned.emit(enemy)
