class_name Enemy extends Area2D

@export var speed: float

@export_group("Internal Nodes")
@export var death_sound: SmartSound


func _physics_process(delta: float) -> void:
	position.x += speed * delta


func die() -> void:
	death_sound.play()
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
