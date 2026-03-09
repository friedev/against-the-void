class_name Projectile extends Enemy

@export var speed: float

var angle: float

func _ready() -> void:
	if Player.instance != null:
		angle = global_position.angle_to_point(Player.instance.global_position)


func _physics_process(delta: float) -> void:
	position += Vector2(speed * delta, 0).rotated(angle)
