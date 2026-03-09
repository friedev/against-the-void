class_name RangedEnemy extends Enemy

@export var speed: float
@export var min_distance: float
@export var max_distance: float
@export var osc_period: float
@export var osc_amplitude: float
@export var projectile_scene: PackedScene

@export_group("Internal Nodes")
@export var shoot_timer: Timer
@export var shoot_sound: SmartSound
@export var telegraph_sprite: Sprite2D

var osc_input := randf()

func _process(_delta: float) -> void:
	if Player.instance != null:
		telegraph_sprite.modulate.a = (1.0 - (shoot_timer.time_left / shoot_timer.wait_time)) ** 2


func _physics_process(delta: float) -> void:
	var prev_osc_input := osc_input
	osc_input += delta / osc_period
	position.y += (sin(osc_input * TAU) - sin(prev_osc_input * TAU)) * osc_amplitude
	if Player.instance != null:
		var angle_to_player := global_position.angle_to_point(Player.instance.global_position)
		var target_distance := global_position.distance_to(Player.instance.global_position) - min_distance
		var movement := Vector2(speed * delta, 0).rotated(angle_to_player).limit_length(maxf(target_distance, 0.0))
		position += movement
		if movement.x != 0:
			scale.x = signf(movement.x)


func _on_shoot_timer_timeout() -> void:
	if Player.instance != null:
		var distance_squared := global_position.distance_squared_to(Player.instance.global_position)
		if distance_squared <= max_distance ** 2:
			shoot()


func shoot() -> void:
	var projectile: Node2D = projectile_scene.instantiate()
	projectile.global_position = telegraph_sprite.global_position
	SignalBus.node_spawned.emit(projectile)
	shoot_sound.randomize_and_play()
