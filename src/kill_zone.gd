class_name KillZone
extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player: Player = body
		player.die()


func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		var enemy: Enemy = area
		# Don't use die() because it triggers screen shake and stuff
		enemy.queue_free()
