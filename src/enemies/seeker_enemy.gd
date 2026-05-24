class_name SeekerEnemy
extends Enemy

@export var max_speed: float
@export var acceleration: float

var velocity: Vector2


func _physics_process(delta: float) -> void:
	if Player.instance != null:
		var velocity_change := Vector2(acceleration * delta, 0).rotated(global_position.angle_to_point(Player.instance.global_position))
		velocity = (velocity + velocity_change).limit_length(max_speed)
	position += velocity * delta
	if velocity.x != 0:
		scale.x = signf(velocity.x)
