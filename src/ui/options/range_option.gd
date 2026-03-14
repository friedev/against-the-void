class_name RangeOption extends Option

@export var default: float

@export var range_control: Range


func get_default() -> Variant:
	return default


func get_option() -> float:
	return range_control.value


func set_option(value: Variant) -> bool:
	if not value is float:
		assert(false)
		return false
	range_control.set_value_no_signal(value as float)
	return super.set_option(value)


func _on_range_control_value_changed(value: float) -> void:
	set_option(value)
