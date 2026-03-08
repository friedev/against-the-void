class_name Enemy extends Area2D

@export var min_speed: float
@export var max_speed: float
@export var min_osc_amplitude: float
@export var max_osc_amplitude: float
@export var min_osc_period: float
@export var max_osc_period: float

@export_group("Internal Nodes")
@export var sprite: AnimatedSprite2D
@export var death_sound: SmartSound
@export var death_particles: GPUParticles2D

@onready var speed := randf_range(min_speed, max_speed)
@onready var osc_amplitude := randf_range(min_osc_amplitude, max_osc_amplitude)
@onready var osc_period := randf_range(min_osc_period, max_osc_period)
@onready var osc_input := randf_range(0.0, 1.0)
@onready var initial_y := position.y

func _ready() -> void:
	scale.x = signf(speed)


func _physics_process(delta: float) -> void:
	position.x += speed * delta
	osc_input += delta / osc_period
	position.y = initial_y + sin(osc_input * TAU) * osc_amplitude


func die() -> void:
	death_sound.randomize_and_play()
	death_particles.restart()
	SignalBus.screen_shake.emit(0.75)
	queue_free()


func try_hit_player(body: Node2D) -> void:
	if body is Player:
		var player: Player = body
		hit_player(player)


func hit_player(player: Player) -> void:
	player.die()


func _on_body_entered(body: Node2D) -> void:
	try_hit_player(body)
