extends AnimationTree

@onready var _player: Player = (get_parent() as Player)
@onready var _player_data: RPlayerData = _player.player_data
@onready var _animation_state_machine_playback: AnimationNodeStateMachinePlayback = \
	(self as AnimationTree).get("parameters/AnimationNodeStateMachine/playback")
@onready var _vfx_animation_player: AnimationPlayer = %VFXAnimationPlayer

func _ready() -> void:
	_vfx_animation_player.speed_scale = 2.0
	_connect_signals()

func _physics_process(_delta: float) -> void:
	_update_animations_speed()
	if(_player_data.hp <=0):
		return

	if(Input.is_action_just_pressed("smash")):
		if(_animation_state_machine_playback.get_current_node() == "steering_up"):
			_animation_state_machine_playback.travel("smash_up")
		elif(_animation_state_machine_playback.get_current_node() == "steering_left"):
			_animation_state_machine_playback.travel("smash_left")
		elif(_animation_state_machine_playback.get_current_node() == "steering_right"):
			_animation_state_machine_playback.travel("smash_right")

	if(_animation_state_machine_playback.get_current_node() != "smash_up" and 
	_animation_state_machine_playback.get_current_node() != "smash_left" and 
	_animation_state_machine_playback.get_current_node() != "smash_right"):
		if(_player.velocity.x > 30):
			_animation_state_machine_playback.travel("steering_right")
		elif(_player.velocity.x < -30):
			_animation_state_machine_playback.travel("steering_left")
		elif(_animation_state_machine_playback.get_current_node() != "smash_up" and 
		_animation_state_machine_playback.get_current_node() != "smash_left" and
		_animation_state_machine_playback.get_current_node() != "smash_right"):
			_animation_state_machine_playback.travel("steering_up")


func _update_animations_speed() -> void:
	if(_animation_state_machine_playback.get_current_node() == "steering_up"):
		(self as AnimationTree).set("parameters/TimeScale/scale", get_animation_speed_coef(_player_data.velocity))
	elif(_animation_state_machine_playback.get_current_node() == "steering_left"
	or _animation_state_machine_playback.get_current_node() == "steering_right"):
		(self as AnimationTree).set("parameters/TimeScale/scale", get_animation_speed_coef(_player_data.steering_velocity))
	else:
		(self as AnimationTree).set("parameters/TimeScale/scale", 1.0)

func get_animation_speed_coef(current_speed: float,lowest_coef: float = 0.25,highest_coef: float = 3.0,
							lowest_speed: float = 25,highest_speed: float = 300) -> float:
		if(current_speed == 0):
			return 0.0
		var linear_derivatve: float = (highest_coef - lowest_coef)/(highest_speed - lowest_speed)
		return clamp(linear_derivatve * current_speed + lowest_coef,lowest_coef, highest_coef)


func _connect_signals() -> void:
	if _player_data.player_dead.connect(_on_player_dead): printerr("Fail: ",get_stack())
	if EventBus.player_damaged.connect(_on_player_damaged): printerr("Fail: ",get_stack())

func _on_player_dead() -> void:
	if(_animation_state_machine_playback.get_current_node() == "steering_up" or 
	_animation_state_machine_playback.get_current_node() == "smash_up"):
		_animation_state_machine_playback.start("death_up")
	elif(_animation_state_machine_playback.get_current_node() == "steering_left" or 
	_animation_state_machine_playback.get_current_node() == "smash_left"):
		_animation_state_machine_playback.start("death_left")
	elif(_animation_state_machine_playback.get_current_node() == "steering_right" or 
	_animation_state_machine_playback.get_current_node() == "smash_right"):
		_animation_state_machine_playback.start("death_right")

func _on_player_damaged(_damage: float) -> void:
	if (randi_range(0,1) == 0 and !_vfx_animation_player.is_playing()):
		_vfx_animation_player.play("blood_left")
	elif(!_vfx_animation_player.is_playing()):
		_vfx_animation_player.play("blood_up")
