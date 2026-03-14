class_name SpawnTimer extends Timer

@export var enemy_scene: PackedScene
## Curve determining the wait time of the spawner over time. Sampling the curve
## at a given number of seconds elapsed will yield the wait time of the timer at
## that time.
@export var wait_time_curve: Curve
## Spawn at a random spawner each time instead of cycling through them in order?
@export var random_spawner: bool
## Spawn an enemy when loaded without waiting for the first timeout?
@export var spawn_on_ready: bool

@export_group("External Nodes")
@export var spawners: Array[EnemySpawner]

var time_elapsed: float

@onready var spawner_index := randi() % len(spawners)

func _ready() -> void:
	if spawn_on_ready:
		spawn()
	start_from_curve()


func start_from_curve() -> void:
	wait_time = wait_time_curve.sample_baked(time_elapsed)
	start()


func spawn() -> bool:
	var spawner := spawners[spawner_index]
	if spawner == null:
		return false
	spawner.spawn(enemy_scene.instantiate() as Enemy)
	spawner_index = randi() % len(spawners) if random_spawner else (spawner_index + 1) % len(spawners)
	return true


func _on_timeout() -> void:
	time_elapsed += wait_time
	if spawn():
		start_from_curve()
