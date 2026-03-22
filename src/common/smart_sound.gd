class_name SmartSound extends AudioStreamPlayer2D

## The maximum pitch change in either direction that can be randomly applied
## when calling `randomize_and_play()`.
@export var pitch_scale_range := 0.25

@onready var base_pitch_scale := pitch_scale

func randomize_and_play(from_position := 0.0) -> void:
	pitch_scale = base_pitch_scale + randf_range(-1.0, +1.0) * pitch_scale_range
	super.play(from_position)


func finish_and_free() -> void:
	if playing:
		var previous_global_position := global_position
		get_parent().remove_child(self )
		SignalBus.node_spawned.emit(self )
		global_position = previous_global_position
		await finished
	queue_free()