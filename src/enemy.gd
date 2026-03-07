class_name Enemy extends CharacterBody2D

@export var speed: float

@export_group("Internal Nodes")
@export var death_sound: SmartSound


func _physics_process(_delta: float) -> void:
	velocity.x = speed
	move_and_slide()


func die() -> void:
	death_sound.play()
	queue_free()