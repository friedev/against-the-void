class_name SmartParticles extends GPUParticles2D

## When the particles node is about to exit the tree, instead start emitting
## particles, then free when finished.
@export var emit_when_exiting := false

## When the particles finish emitting, free this node.
@export var free_when_finished := false

## If the particles node is about to exit the tree, instead detach it, finish
## emitting, and then free it.
@export var finish_before_exiting := true

func _on_finished() -> void:
	if free_when_finished:
		queue_free()


func _exit_tree() -> void:
	if emit_when_exiting or (finish_before_exiting and emitting):
		one_shot = true
		var previous_global_position := global_position
		await get_parent().tree_exited
		get_parent().remove_child(self )
		SignalBus.node_spawned.emit(self )
		global_position = previous_global_position
		if emit_when_exiting:
			restart()
		free_when_finished = true
