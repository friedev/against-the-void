extends Label

var running := true
var time: float

func _ready() -> void:
	SignalBus.game_over.connect(_on_game_over)


func _process(delta: float) -> void:
	time += delta
	text = "%02d:%02d.%02d" % [int(time / 60.0), int(time) % 60, int(time * 100.0) % 100]
	

func _on_game_over() -> void:
	set_process(false)