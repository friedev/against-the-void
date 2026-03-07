class_name Player extends CharacterBody2D

@export var max_speed: Vector2
@export var jump_speed: float
@export var recoil_speed: float
@export var acceleration: float
@export var deceleration: float
@export var fast_fall_acceleration: float
@export var attack_duration: float
@export var attack_cooldown: float
@export var air_jumps: int

@export_group("Internal Nodes")
@export var sprite: AnimatedSprite2D
@export var sword_area: Area2D
@export var attack_sound: SmartSound
@export var jump_sound: SmartSound
@export var camera: Camera2D

@onready var initial_position := position
@onready var jumps_left := air_jumps


func _physics_process(delta: float) -> void:
	# Add gravity
	velocity += get_gravity() * delta
	velocity.y = minf(velocity.y, max_speed.y)

	# Handle jump
	if Input.is_action_just_pressed("jump"):
		jump()
	elif not Input.is_action_pressed("jump") and velocity.y < 0:
		# Variable jump height: quickly stop going up if jump is released
		velocity.y += fast_fall_acceleration * delta

	var input_direction := Input.get_axis("move_left", "move_right")
	var target_speed := input_direction * max_speed.x
	var current_acceleration := deceleration
	if input_direction != 0.0 and (
		sign(target_speed) == sign(velocity.x) and abs(target_speed) > abs(velocity.x)
	):
		current_acceleration = acceleration
	velocity.x = move_toward(velocity.x, target_speed, current_acceleration * delta)

	move_and_slide()

	if not is_attacking():
		if input_direction < 0.0:
			sprite.flip_h = true
			sword_area.scale.x = -1.0
		elif input_direction > 0.0:
			sprite.flip_h = false
			sword_area.scale.x = +1.0


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		attack()


func jump() -> bool:
	if jumps_left == 0:
		return false
	jumps_left -= 1
	velocity.y = - jump_speed
	jump_sound.play()
	return true


func attack() -> bool:
	if is_attacking():
		return false
	attack_sound.play()
	sprite.play("attack")
	sword_area.monitoring = true
	for body in sword_area.get_overlapping_areas():
		try_hit(body)
	await get_tree().create_timer(attack_duration).timeout
	sprite.play("attack_recover")
	sword_area.monitoring = false
	await get_tree().create_timer(attack_cooldown).timeout
	sprite.play("default")
	return true


func is_attacking() -> bool:
	return sprite.animation == "attack" or sprite.animation == "attack_recover"

	
func die() -> void:
	var camera_position := camera.get_screen_center_position()
	remove_child(camera)
	SignalBus.node_spawned.emit(camera)
	camera.global_position = camera_position
	camera.reset_smoothing()
	queue_free()


func try_hit(body: Node2D) -> void:
	if body is Enemy:
		hit(body as Enemy)


func hit(enemy: Enemy) -> void:
	enemy.die()
	velocity.y = - recoil_speed
	jumps_left = air_jumps


func _on_sword_area_area_entered(area: Area2D) -> void:
	try_hit(area)
