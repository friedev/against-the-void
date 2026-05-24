class_name BasicEnemy
extends Enemy

@export var min_speed: float
@export var max_speed: float
@export var osc_period: float
@export var osc_amplitude: float

@onready var speed := randf_range(min_speed, max_speed)
@onready var initial_y := position.y
var osc_input := randf()


func _ready() -> void:
	var speed_mod := signf(scale.x)
	min_speed *= speed_mod
	max_speed *= speed_mod
	speed *= speed_mod


func _physics_process(delta: float) -> void:
	position.x += speed * delta
	osc_input += delta / osc_period
	position.y = initial_y + sin(osc_input * TAU) * osc_amplitude
