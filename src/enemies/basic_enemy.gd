class_name BasicEnemy extends Enemy

@export var min_speed: float
@export var max_speed: float
@export var min_osc_amplitude: float
@export var max_osc_amplitude: float
@export var min_osc_period: float
@export var max_osc_period: float

@onready var speed := randf_range(min_speed, max_speed)
@onready var osc_amplitude := randf_range(min_osc_amplitude, max_osc_amplitude)
@onready var osc_period := randf_range(min_osc_period, max_osc_period)
@onready var osc_input := randf_range(0.0, 1.0)
@onready var initial_y := position.y

func _ready() -> void:
	var speed_mod := signf(scale.x)
	min_speed *= speed_mod
	max_speed *= speed_mod
	speed *= speed_mod


func _physics_process(delta: float) -> void:
	position.x += speed * delta
	osc_input += delta / osc_period
	position.y = initial_y + sin(osc_input * TAU) * osc_amplitude
