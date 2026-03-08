class_name EnemySpawner extends Node2D

@export var flip_h: bool
@export var enemy_scenes: Array[PackedScene]
@export var spawn_time: float

@export_group("Internal Nodes")
@export var spawn_timer: Timer

func _ready() -> void:
	spawn_timer.wait_time = spawn_time
	spawn_timer.start()


func instantiate_random_enemy() -> Enemy:
	return enemy_scenes[randi() % len(enemy_scenes)].instantiate()


func _on_spawn_timer_timeout() -> void:
	var enemy := instantiate_random_enemy()
	enemy.global_position = Vector2(global_position.x, lerpf(0.0, global_position.y, randf()))
	if flip_h:
		enemy.scale.x *= -1.0
	SignalBus.node_spawned.emit(enemy)
