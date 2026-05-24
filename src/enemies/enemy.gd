class_name Enemy
extends Area2D

signal died

@export var death_screen_shake: float

@export_group("Internal Nodes")
@export var sprite: AnimatedSprite2D
@export var death_sound: SmartSound
@export var death_particles: GPUParticles2D


func die() -> void:
	death_sound.randomize_and_play()
	death_particles.restart()
	SignalBus.screen_shake.emit(death_screen_shake)
	died.emit()
	queue_free()


func try_hit_player(body: Node2D) -> void:
	if body is Player:
		var player: Player = body
		hit_player(player)


func hit_player(player: Player) -> void:
	player.die()


func _on_body_entered(body: Node2D) -> void:
	try_hit_player(body)
