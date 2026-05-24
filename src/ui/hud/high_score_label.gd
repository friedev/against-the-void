class_name HighScoreLabel
extends Label

func _ready() -> void:
	Save.best_time.changed.connect(_on_best_time_changed)
	SignalBus.game_loading.connect(_on_game_loading)
	SignalBus.game_over.connect(_on_game_over)
	update_text()


func update_text() -> void:
	var best_time: int = Save.best_time.get_value()
	visible = best_time > 0
	modulate = Color.GRAY
	text = "Best: %s" % Utility.format_msec(best_time)


func _on_game_over() -> void:
	show()


func _on_best_time_changed() -> void:
	modulate = Color.YELLOW
	text = "New Best"


func _on_game_loading() -> void:
	# Update text here to avoid a race condition with Save receiving game_over
	update_text()
	hide()
