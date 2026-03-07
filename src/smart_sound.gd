class_name SmartSound extends AudioStreamPlayer2D

## When the sound finishes playing, free it.
@export var free_when_finished := false

## If the sound is about to exit the tree, instead detach it, finish playing it,
## and then free it.
@export var finish_before_exiting := true

## The maximum pitch change in either direction that can be randomly applied
## when calling `randomize_and_play()`.
@export var pitch_scale_range := 0.25

@onready var base_pitch_scale := self.pitch_scale

func randomize_and_play(from_position := 0.0) -> void:
	self.pitch_scale = (
		self.base_pitch_scale
		+ randf_range(-1.0, +1.0) * self.pitch_scale_range
	)
	super.play(from_position)


func _on_finished() -> void:
	if self.free_when_finished:
		self.queue_free()


func _exit_tree() -> void:
	if self.finish_before_exiting and self.playing:
		var previous_global_position := self.global_position
		await self.get_parent().tree_exited
		self.get_parent().remove_child(self)
		SignalBus.node_spawned.emit(self)
		self.global_position = previous_global_position
		self.free_when_finished = true
