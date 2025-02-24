class_name RunController
extends Node


var _life_timer: LifeTimer = preload("res://scenes/ps_timer.tscn").instantiate()
var _player_data: RPlayerData = preload("res://godot_resources/r_default_player_data.tres")

func _init() -> void:
	_life_timer.set_time(_player_data.default_start_time)

func _ready() -> void:
	add_child(_life_timer)
	_connect_signals()

func start_level_run() -> void:
	_life_timer.continue_timer()

func end_level_lose() -> void:
	print("You lost")

func end_level_win() -> void:
	_life_timer.stop_timer()

func _connect_signals() -> void:
	if _life_timer.life_timer_timeout.connect(_on_life_timer_timeout): printerr("Fail: ",get_stack())

func _on_life_timer_timeout() -> void:
	end_level_lose()
	
