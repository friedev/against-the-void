class_name Enemy extends Area2D

@export var min_speed: float
@export var max_speed: float

@export_group("Internal Nodes")
@export var sprite: AnimatedSprite2D
@export var death_sound: SmartSound
@export var death_particles: GPUParticles2D

@onready var speed := randf_range(min_speed, max_speed)

func _ready() -> void:
	if speed < 0.0:
		sprite.flip_h = not sprite.flip_h


func _physics_process(delta: float) -> void:
	position.x += speed * delta


func die() -> void:
	death_sound.randomize_and_play()
	SignalBus.screen_shake.emit(1.0)
	queue_free()


func try_hit_player(body: Node2D) -> void:
	if body is Player:
		var player: Player = body
		hit_player(player)


func hit_player(player: Player) -> void:
	player.die()


func _on_body_entered(body: Node2D) -> void:
	try_hit_player(body)
