class_name Stat extends Node

signal changed

var section: String
var key: String
var default: Variant

func _init(section_: String, key_: String, default_: Variant = null) -> void:
	section = section_
	key = key_
	default = default_
	Save.stats.append(self )


func get_value() -> Variant:
	return Save.config.get_value(section, key, default)


func set_value(value: Variant) -> void:
	var previous_value: Variant = get_value()
	Save.config.set_value(section, key, value)
	if previous_value != value:
		changed.emit()