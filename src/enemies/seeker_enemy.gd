class_name SeekerEnemy extends BasicEnemy

var velocity: Vector2

# Override
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var old_osc := get_osc()
	update_osc(delta)
	if Player.instance != null:
		velocity = Vector2(speed * delta, 0).rotated(global_position.angle_to_point(Player.instance.global_position))
	position += velocity + velocity.rotated(PI * 0.5).normalized() * (get_osc() - old_osc)
	scale.x = signf(velocity.x)
