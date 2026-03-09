class_name SeekerEnemy extends Enemy

@export var min_speed: float
@export var max_speed: float
@export var acceleration: float

var velocity: Vector2

@onready var speed := randf_range(min_speed, max_speed)

func _physics_process(delta: float) -> void:
	if Player.instance != null:
		velocity = Vector2(speed * delta, 0).rotated(global_position.angle_to_point(Player.instance.global_position))
	position += velocity
	if velocity.x != 0:
		scale.x = signf(velocity.x)
