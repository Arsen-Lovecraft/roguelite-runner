class_name UIStamina
extends Control

@onready var _player_data: RPlayerData = preload("res://godot_resources/r_default_player_data.tres")
@onready var _stamina_texture_progress_bar: TextureProgressBar = %StaminaTextureProgressBar
@onready var _stamina_text: Label = %StaminaText

func _physics_process(delta: float) -> void:
	_stamina_texture_progress_bar.max_value = _player_data.max_stamina
	_stamina_texture_progress_bar.value = _player_data.stamina
	_stamina_text.text = str(_player_data.stamina) + "/" + str(_player_data.max_stamina)
