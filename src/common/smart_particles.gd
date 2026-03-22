class_name SmartParticles extends GPUParticles2D

func finish_and_free() -> void:
	if emitting:
		if not one_shot:
			emitting = false
			one_shot = true
		var previous_global_position := global_position
		get_parent().remove_child(self )
		SignalBus.node_spawned.emit(self )
		global_position = previous_global_position
		await finished
	queue_free()