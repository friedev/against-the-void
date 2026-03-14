class_name Void extends KillZone

## Singleton instance.
static var instance: Void

## Speed at which the void rises over time.
@export var speed_curve: Curve

func _enter_tree() -> void:
	assert(instance == null)
	instance = self


func _exit_tree() -> void:
	instance = null


func _process(delta: float) -> void:
	if Player.instance != null:
		var time := (Time.get_ticks_msec() - Globals.start_ticks) / 1000.0
		var speed := speed_curve.sample_baked(time)
		position.y += speed * delta