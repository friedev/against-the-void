extends Camera2D

func _ready() -> void:
	SignalBus.game_loading.connect(_on_game_loading)
	

func _on_game_loading() -> void:
	enabled = false