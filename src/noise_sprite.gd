class_name NoiseSprite extends Sprite2D

signal texture_updated

var is_texture_updated := false

func _ready() -> void:
	SignalBus.game_loading.connect(_on_game_loading)
	regenerate()


func _on_game_loading() -> void:
	regenerate()


func regenerate() -> void:
	is_texture_updated = false
	var noise_texture: NoiseTexture2D = texture
	var fastnoiselite: FastNoiseLite = noise_texture.noise
	fastnoiselite.seed = randi()
	await noise_texture.changed
	is_texture_updated = true
	texture_updated.emit()