class_name Enemy extends CharacterBody2D

@export var speed: float


func _physics_process(_delta: float) -> void:
	velocity.x = speed
	move_and_slide()