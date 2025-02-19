class_name Player
extends CharacterBody2D

@export var _player_data: RPlayerData

@onready var _animation_state_machine: AnimationNodeStateMachinePlayback = %PlayerAnimationTree.get("parameters/playback")
@onready var _vfx_animation_player: AnimationPlayer = %VFXAnimationPlayer

func _ready() -> void:
	_connect_signals()

func _physics_process(_delta: float) -> void:
	_move_player()
	_handle_steering()
	_handle_smashing()
	_handle_animation()
	@warning_ignore("return_value_discarded")
	move_and_slide()

func _connect_signals() -> void:
	if _player_data.player_dead.connect(_on_player_dead): printerr("Fail: ",get_stack()) 

func _move_player() -> void:
	if(_player_data.speed > -velocity.y):
		velocity += Vector2(0,-_player_data.speed/5)

func _handle_steering() -> void:
	if(Input.is_action_pressed("turn_right")):
		if(_player_data.steering_velocity > velocity.x):
			velocity += Vector2(_player_data.steering_velocity/5, 0)
	elif(Input.is_action_pressed("turn_left")):
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
	if(velocity.x > 30):
		_animation_state_machine.travel("steering_right")
	elif(velocity.x < -30):
		_animation_state_machine.travel("steering_left")
	elif(_animation_state_machine.get_current_node() != "smash_up" and 
	_animation_state_machine.get_current_node() != "smash_left" and
	_animation_state_machine.get_current_node() != "smash_right"):
		_animation_state_machine.travel("steering_up")

	if(Input.is_action_just_pressed("smash")):
		if(_animation_state_machine.get_current_node() == "steering_up"):
			_animation_state_machine.travel("smash_up")
		elif(_animation_state_machine.get_current_node() == "steering_left"):
			_animation_state_machine.travel("smash_left")
		elif(_animation_state_machine.get_current_node() == "steering_right"):
			_animation_state_machine.travel("smash_right")

func _on_player_dead() -> void:
	_animation_state_machine.travel("dead")
