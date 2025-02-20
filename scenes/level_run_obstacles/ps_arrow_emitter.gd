class_name ArrowEmitter
extends Node2D


@export var marker_start: Marker2D
@export var marker_end: Marker2D

var speed: float = 100:
	set(value):
		if(value <= 0):
			speed = 0
		else:
			speed = value
var respawn_cooldown: float = 2.0:
	set(value):
		if(value <= 0):
			respawn_cooldown = 0.25
		else:
			respawn_cooldown = value
		_cooldown.wait_time = value

var _arrows_ps: PackedScene = preload("res://scenes/level_run_obstacles/ps_dynamic_obstacle.tscn")
var _start_position: Vector2
var _end_position: Vector2
var _direction: Vector2
var _arrows_pool: Array[DynamicObstacle]

@onready var _cooldown: Timer = %Cooldown

func _ready() -> void:
	_init_state()
	_connect_signals()

func _physics_process(delta: float) -> void:
	for arrow: DynamicObstacle in _arrows_pool:
		if(arrow == null):
			continue
		if (arrow.global_position.distance_to(_end_position) <= speed*delta):
			_arrows_pool.erase(arrow)
			arrow.queue_free()
		arrow.global_position += speed * _direction * delta

func _init_state() -> void:
	_cooldown.wait_time = respawn_cooldown
	_start_position = marker_start.global_position
	_end_position = marker_end.global_position
	_direction = (_end_position - _start_position).normalized()

func _connect_signals() -> void:
	if _cooldown.timeout.connect(_on_cooldown_timeout): printerr("Fail: ",get_stack())

func _create_arrow() -> void:
	var arrows: DynamicObstacle = _arrows_ps.instantiate()
	arrows.global_position = _start_position
	_arrows_pool.append(arrows)
	self.add_child(arrows)

func _on_cooldown_timeout() -> void:
	_create_arrow()
