class_name RunController
extends Node

signal won()
signal lost()

var _player_data: RPlayerData = preload("res://godot_resources/r_default_player_data.tres")
var _life_timer: LifeTimer 
var _damage_traits_dispatcher: DamageTraitsDispatcher

func _init() -> void:
	self.add_to_group("run_controller")
	_life_timer = preload("res://scenes/level_run/ps_life_timer.tscn").instantiate()
	_damage_traits_dispatcher = DamageTraitsDispatcher.new()

func _ready() -> void:
	_life_timer.set_time(_player_data.default_start_time)
	add_child(_life_timer)
	_connect_signals()
	start_level_run()

func start_level_run() -> void:
	_life_timer.continue_timer()

func end_level_lose() -> void:
	lost.emit()

func end_level_win() -> void:
	won.emit()
	_life_timer.stop_timer()

func _connect_signals() -> void:
	if _life_timer.life_timer_timeout.connect(_on_life_timer_timeout): printerr("Fail: ",get_stack())
	if (get_tree().get_first_node_in_group("win_area") as WinArea).player_completed_level.connect(_on_player_completed_level): printerr("Fail: ",get_stack())
	if _damage_traits_dispatcher.player_is_damaged.connect((get_tree().get_first_node_in_group("player")as Player)._on_player_is_damaged): printerr("Fail: ",get_stack())
	if _life_timer.life_timer_timeout.connect((get_tree().get_first_node_in_group("player") as Player)._on_lost): printerr("Fail: ",get_stack())

func _on_life_timer_timeout() -> void:
	end_level_lose()

func _on_player_completed_level() -> void:
	end_level_win()
