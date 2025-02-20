class_name Player
extends CharacterBody2D

var _player_data: RPlayerData = preload("res://godot_resources/r_player_data.tres")

@onready var _animation_state_machine_playback: AnimationNodeStateMachinePlayback = %PlayerAnimationTree.get("parameters/AnimationNodeStateMachine/playback")
@onready var _vfx_animation_player: AnimationPlayer = %VFXAnimationPlayer

func _ready() -> void:
	_connect_signals()

func _physics_process(_delta: float) -> void:
	_move_player()
	_handle_steering()
	_handle_smashing()
	_handle_animation()
	@warning_ignore("return_value_discarded")
	velocity = velocity.clamp(
		Vector2(-_player_data.steering_velocity,-_player_data.velocity),
		Vector2(_player_data.steering_velocity,0)
		)
	move_and_slide()

func _connect_signals() -> void:
	if _player_data.player_dead.connect(_on_player_dead): printerr("Fail: ",get_stack()) 

func _move_player() -> void:
	if(_player_data.velocity > -velocity.y):
		velocity += Vector2(0,-_player_data.velocity/5)

func _handle_steering() -> void:
	if(Input.is_action_pressed("turn_right")):
		_player_data.steering_velocity -= 1.0
		_player_data.velocity -= 1.0
		if(_player_data.steering_velocity > velocity.x):
			velocity += Vector2(_player_data.steering_velocity/5, 0)
	elif(Input.is_action_pressed("turn_left")):
		_player_data.steering_velocity += 1.0
		_player_data.velocity += 1.0
		if(_player_data.steering_velocity > -velocity.x):
			velocity += Vector2(-_player_data.steering_velocity/5, 0)
	else:
		if(abs(velocity.x) > 1):
			velocity.x = lerp(velocity.x, 0.0, 0.15)
		else:
			velocity.x = 0

func _handle_smashing() -> void:
	if(Input.is_action_pressed("smash")):
		pass

func _handle_animation() -> void:
	_update_animations_speed()
	if(velocity.x > 30):
		_animation_state_machine_playback.travel("steering_right")
	elif(velocity.x < -30):
		_animation_state_machine_playback.travel("steering_left")
	elif(_animation_state_machine_playback.get_current_node() != "smash_up" and 
	_animation_state_machine_playback.get_current_node() != "smash_left" and
	_animation_state_machine_playback.get_current_node() != "smash_right"):
		_animation_state_machine_playback.travel("steering_up")

	if(Input.is_action_just_pressed("smash")):
		if(_animation_state_machine_playback.get_current_node() == "steering_up"):
			_animation_state_machine_playback.travel("smash_up")
		elif(_animation_state_machine_playback.get_current_node() == "steering_left"):
			_animation_state_machine_playback.travel("smash_left")
		elif(_animation_state_machine_playback.get_current_node() == "steering_right"):
			_animation_state_machine_playback.travel("smash_right")

func _update_animations_speed() -> void:
	if(_animation_state_machine_playback.get_current_node() == "steering_up"):
		%PlayerAnimationTree.set("parameters/TimeScale/scale", get_animation_speed_coef(_player_data.velocity))
	elif(_animation_state_machine_playback.get_current_node() == "steering_left"
	or _animation_state_machine_playback.get_current_node() == "steering_right"):
		%PlayerAnimationTree.set("parameters/TimeScale/scale", get_animation_speed_coef(_player_data.steering_velocity))
	else:
		%PlayerAnimationTree.set("parameters/TimeScale/scale", 1.0)

func get_animation_speed_coef(current_speed: float,lowest_coef: float = 0.25,highest_coef: float = 3.0,
							lowest_speed: float = 25,highest_speed: float = 300) -> float:
		var linear_derivatve: float = (highest_coef - lowest_coef)/(highest_speed - lowest_speed)
		return clamp(linear_derivatve * current_speed + lowest_coef,lowest_coef, highest_coef)

func _on_player_dead() -> void:
	_animation_state_machine_playback.travel("dead")
