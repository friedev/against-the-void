class_name Player extends CharacterBody2D

## Singleton instance.
static var instance: Player

@export var max_speed: Vector2
@export var jump_speed: float
@export var pogo_recoil_speed: float
@export var non_pogo_recoil_speed: float
@export var acceleration: float
@export var deceleration: float
@export var fast_fall_acceleration: float
@export var attack_duration: float
@export var attack_cooldown: float
@export var air_jumps: int

@export_group("Internal Nodes")
@export var sprite: AnimatedSprite2D
@export var sword_area: Area2D
@export var camera: Camera2D
@export var attack_sound: SmartSound
@export var jump_sound: SmartSound
@export var death_sound: SmartSound
@export var jump_particles: GPUParticles2D
@export var death_particles: GPUParticles2D

@onready var initial_position := position
@onready var jumps_left := air_jumps

var is_attack_buffered := false
var is_attacking := false
var animation_state := 0

func _enter_tree() -> void:
	assert(instance == null)
	instance = self


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

	if not is_attacking:
		if input_direction < 0.0:
			sprite.flip_h = true
		elif input_direction > 0.0:
			sprite.flip_h = false


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		attack()


func jump() -> bool:
	if jumps_left == 0:
		return false
	jumps_left -= 1
	velocity.y = - jump_speed
	jump_sound.randomize_and_play()
	jump_particles.restart()
	return true


func attack() -> void:
	if is_attacking:
		is_attack_buffered = true
		return
	is_attacking = true
	attack_sound.randomize_and_play()

	var attack_direction := Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	if attack_direction.y != 0.0:
		attack_direction.x = 0.0
	if attack_direction == Vector2.ZERO:
		attack_direction = Vector2.LEFT if sprite.flip_h else Vector2.RIGHT
	attack_direction = attack_direction.normalized()

	sword_area.rotation = attack_direction.angle()
	sword_area.show()
	animation_state = (animation_state + 1) % 2
	sprite.play("idle_%d" % animation_state)

	sword_area.monitoring = true
	for body in sword_area.get_overlapping_areas():
		try_hit(body)
	await get_tree().create_timer(attack_duration).timeout
	sword_area.monitoring = false
	sword_area.hide()
	await get_tree().create_timer(attack_cooldown).timeout
	is_attacking = false
	if is_attack_buffered:
		is_attack_buffered = false
		attack()


func die() -> void:
	death_particles.restart()
	death_sound.randomize_and_play()
	SignalBus.screen_shake.emit(1.0)
	reparent_child(camera, camera.get_screen_center_position())
	camera.reset_smoothing()
	queue_free()
	SignalBus.game_over.emit()


func reparent_child(child: Node2D, new_position := Vector2.INF) -> void:
	if new_position == Vector2.INF:
		new_position = (child as Node2D).global_position
	remove_child(child)
	SignalBus.node_spawned.emit.call_deferred(child)
	child.global_position = new_position


func try_hit(body: Node2D) -> void:
	if body is Enemy:
		hit(body as Enemy)


func hit(enemy: Enemy) -> void:
	enemy.die()
	var recoil_direction := Vector2(1, 0).rotated(sword_area.rotation)
	if recoil_direction.y > 0:
		velocity.y = - pogo_recoil_speed
		jumps_left = air_jumps
	else:
		velocity -= recoil_direction * non_pogo_recoil_speed


func _on_sword_area_area_entered(area: Area2D) -> void:
	try_hit(area)
