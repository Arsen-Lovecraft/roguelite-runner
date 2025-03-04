class_name LifeTimer
extends Node

signal life_timer_timeout()
signal time_updated(time: int)

var _time_stamp: float = 0

@onready var _time_left_timer: Timer = %TimeLeft

func _ready() -> void:
	_connect_signals()
	_time_left_timer.wait_time = _time_stamp
	life_timer_timeout.emit()
	emit_state_every_t(1.0)

func set_time(time: int) -> void:
	_time_stamp = float(time)

func continue_timer() -> void:
	_time_left_timer.start(_time_stamp)
	time_updated.emit(_time_left_timer.time_left)

func stop_timer() -> void:
	_time_stamp = _time_left_timer.time_left
	_time_left_timer.stop()

func _connect_signals() -> void:
	if _time_left_timer.timeout.connect(_on_time_left_timer): printerr("Fail: ",get_stack()) 

func emit_state_every_t(time: float) -> void:
	while true:
		await get_tree().create_timer(time).timeout
		if(!_time_left_timer.is_stopped()):
			time_updated.emit(_time_left_timer.time_left)

func _on_time_left_timer() -> void:
	life_timer_timeout.emit()
	##TODO Decouple
	EventBus.life_time_left.emit()
