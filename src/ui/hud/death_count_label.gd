class_name DeathCountLabel
extends Label

func _ready() -> void:
	Save.death_count.changed.connect(_on_death_count_changed)
	SignalBus.game_loading.connect(_on_game_loading)
	SignalBus.game_over.connect(_on_game_over)
	update_text()


func update_text() -> void:
	var death_count: int = Save.death_count.get_value()
	visible = death_count > 0
	text = "Deaths: %d" % death_count


func _on_game_over() -> void:
	show()


func _on_death_count_changed() -> void:
	update_text()


func _on_game_loading() -> void:
	hide()
