class_name SmartSound extends AudioStreamPlayer2D

## When the sound finishes playing, free it.
@export var free_when_finished := false

## If the sound is about to exit the tree, instead detach it, finish playing it,
## and then free it.
@export var finish_before_exiting := true

## The maximum pitch change in either direction that can be randomly applied
## when calling `randomize_and_play()`.
@export var pitch_scale_range := 0.25

@onready var base_pitch_scale := pitch_scale

func randomize_and_play(from_position := 0.0) -> void:
	pitch_scale = base_pitch_scale + randf_range(-1.0, +1.0) * pitch_scale_range
	super.play(from_position)


func _on_finished() -> void:
	if free_when_finished:
		queue_free()


func _exit_tree() -> void:
	if finish_before_exiting and playing:
		var previous_global_position := global_position
		await get_parent().tree_exited
		get_parent().remove_child(self )
		SignalBus.node_spawned.emit(self )
		global_position = previous_global_position
		free_when_finished = true