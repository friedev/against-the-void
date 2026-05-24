extends Parallax2D

@onready var initial_scroll_offset := scroll_offset


func _process(_delta: float) -> void:
	if Void.instance != null:
		scroll_offset.y = Void.instance.position.y + initial_scroll_offset.y
