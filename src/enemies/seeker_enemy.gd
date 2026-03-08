extends Enemy

@export var min_speed: float
@export var max_speed: float

@onready var speed := randf_range(min_speed, max_speed)

var velocity: Vector2

func _physics_process(delta: float) -> void:
	if Player.instance != null:
		velocity = Vector2(speed * delta, 0).rotated(global_position.angle_to_point(Player.instance.global_position))
	position += velocity
	scale.x = signf(velocity.x)
