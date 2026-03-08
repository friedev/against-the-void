extends Sprite2D

signal texture_updated

func _ready() -> void:
	var noise_texture: NoiseTexture2D = texture
	var fastnoiselite: FastNoiseLite = noise_texture.noise
	fastnoiselite.seed = randi()
	hide()
	await noise_texture.changed
	show()
	texture_updated.emit()