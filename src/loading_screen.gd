extends CanvasLayer

func _ready() -> void:
	SignalBus.game_loading.connect(show)
	SignalBus.game_loaded.connect(hide)
