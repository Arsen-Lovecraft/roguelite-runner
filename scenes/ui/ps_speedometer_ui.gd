class_name UISpeedometr
extends Control

var _lowest_speed: float = 0
var _highest_speed: float = 300

@onready var _speedometr_arrow_texture_rect: TextureRect = %SpeedometrArrowTextureRect
@onready var _speed_label: Label = %SpeedLabel
@onready var _player_data: RPlayerData = preload("res://godot_resources/r_default_player_data.tres")
@onready var max_speed_label: Label = %MaxSpeedLabel

func _physics_process(_delta: float) -> void:
	_set_speed(10, _player_data.current_velocity)
	_speedometr_arrow_texture_rect.rotation_degrees = _map_speed_to_rot_angle()  + randf_range(-3.0, 2.0)
	_speed_label.text = str(-(get_tree().get_first_node_in_group("player") as Player).velocity.y) + " km/h"
	max_speed_label.text = str(_player_data.current_velocity) + " km/h max"

func _set_speed(lowest: float, highest: float) -> void:
	if(lowest > highest or lowest < 0):
		print("Error of setting up speedometr boundaries: " + str(get_stack()))
		return
	_lowest_speed = lowest
	_highest_speed = highest

func _map_speed_to_rot_angle() -> float:
	# -28 - high, -174 - low boundaries for %SpeedometrArrowTextureRect
	var linear_derivatve: float = -(28 - 174)/(_highest_speed - _lowest_speed)
	return clamp(linear_derivatve * -(get_tree().get_first_node_in_group("player") as Player).velocity.y - 174, -174, -28)
