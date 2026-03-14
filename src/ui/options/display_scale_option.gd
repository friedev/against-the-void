class_name DisplayScaleOption extends RangeOption

@export var pixel_size: int

func get_option() -> float:
	return get_tree().root.content_scale_factor * pixel_size


func set_option(value: Variant) -> bool:
	if super.set_option(value):
		get_tree().root.content_scale_factor = value / pixel_size
		return true
	return false
