extends AnimationTree

@onready var _player: Player = (get_parent() as Player)
@onready var _player_data: RPlayerData = preload("res://godot_resources/r_default_player_data.tres")
@onready var _animation_state_machine_playback: AnimationNodeStateMachinePlayback = \
	(self as AnimationTree).get("parameters/AnimationNodeStateMachine/playback")
@onready var _vfx_animation_player: AnimationPlayer = %VFXAnimationPlayer

func _ready() -> void:
	_vfx_animation_player.speed_scale = 2.0
	_connect_signals()

func _physics_process(_delta: float) -> void:
	_update_animations_speed()

func _connect_signals() -> void:
	if _player.lost.connect(_on_lost): printerr("Fail: ",get_stack())
	if _player.moved_left.connect(_on_moved_left): printerr("Fail: ",get_stack())
	if _player.moved_right.connect(_on_moved_right): printerr("Fail: ",get_stack())
	if _player.moved_up.connect(_on_moved_up): printerr("Fail: ",get_stack())
	if _player.smashed.connect(_on_smashed): printerr("Fail: ",get_stack())
	if _player.player_is_damaged.connect(_on_player_is_damaged): printerr("Fail: ",get_stack())

func _on_lost() -> void:
	if(_animation_state_machine_playback.get_current_node() == "steering_up" or 
	_animation_state_machine_playback.get_current_node() == "smash_up"):
		_animation_state_machine_playback.start("death_up")
	elif(_animation_state_machine_playback.get_current_node() == "steering_left" or 
	_animation_state_machine_playback.get_current_node() == "smash_left"):
		_animation_state_machine_playback.start("death_left")
	elif(_animation_state_machine_playback.get_current_node() == "steering_right" or 
	_animation_state_machine_playback.get_current_node() == "smash_right"):
		_animation_state_machine_playback.start("death_right")

func _on_moved_left() -> void:
	if(_player.velocity.x < 30):
		_animation_state_machine_playback.travel("steering_left")

func _on_moved_right() -> void:
	if(_player.velocity.x > 30):
		_animation_state_machine_playback.travel("steering_right")

func _on_moved_up() -> void:
	_animation_state_machine_playback.travel("steering_up")

func _on_smashed() -> void:
	if(_animation_state_machine_playback.get_current_node() == "steering_up"):
		_animation_state_machine_playback.travel("smash_up")
	elif(_animation_state_machine_playback.get_current_node() == "steering_left"):
		_animation_state_machine_playback.travel("smash_left")
	elif(_animation_state_machine_playback.get_current_node() == "steering_right"):
		_animation_state_machine_playback.travel("smash_right")

func _on_player_is_damaged() -> void:
	if (randi_range(0,1) == 0 and !_vfx_animation_player.is_playing()):
		_vfx_animation_player.play("blood_left")
	elif(!_vfx_animation_player.is_playing()):
		_vfx_animation_player.play("blood_up")

func _update_animations_speed() -> void:
	if(_animation_state_machine_playback.get_current_node() == "steering_up"):
		(self as AnimationTree).set("parameters/TimeScale/scale", 
								_get_animation_speed_coef(_player_data.current_velocity, 0, _player_data.max_velocity))
	elif(_animation_state_machine_playback.get_current_node() == "steering_left"
	or _animation_state_machine_playback.get_current_node() == "steering_right"):
		(self as AnimationTree).set("parameters/TimeScale/scale", 
								_get_animation_speed_coef(_player_data.current_velocity, 0, _player_data.max_velocity))
	else:
		(self as AnimationTree).set("parameters/TimeScale/scale", 1.0)

func _get_animation_speed_coef(current_speed: float,
	lowest_speed: float = 25,highest_speed: float = 300,
	lowest_coef: float = 0.25,highest_coef: float = 3.0,) -> float:
		if(current_speed == 0):
			return 0.0
		var linear_derivatve: float = (highest_coef - lowest_coef)/(highest_speed - lowest_speed)
		return clamp(linear_derivatve * current_speed + lowest_coef,lowest_coef, highest_coef)
