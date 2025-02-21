class_name Player
extends CharacterBody2D

var player_data: RPlayerData = preload("res://godot_resources/r_player_data.tres")

func _ready() -> void:
	_connect_signals()

func _physics_process(_delta: float) -> void:
	_move_player()
	_handle_steering()
	_handle_smashing()
	velocity = velocity.clamp(
		Vector2(-player_data.steering_velocity,-player_data.velocity),
		Vector2(player_data.steering_velocity,0)
		)
	@warning_ignore("return_value_discarded")
	move_and_slide()

func _connect_signals() -> void:
	if player_data.player_dead.connect(_on_player_dead): printerr("Fail: ",get_stack())
	if EventBus.player_damaged.connect(_on_player_damaged): printerr("Fail: ",get_stack())

func _move_player() -> void:
	if(player_data.velocity > -velocity.y):
		velocity += Vector2(0,-player_data.velocity/5)

func _handle_steering() -> void:
	if(Input.is_action_pressed("turn_right")):
		#TEST
		player_data.steering_velocity -= 1.0
		player_data.velocity -= 1.0
		#TEST
		if(player_data.steering_velocity > velocity.x):
			velocity += Vector2(player_data.steering_velocity/5, 0)
	elif(Input.is_action_pressed("turn_left")):
		#TEST
		player_data.steering_velocity += 1.0
		player_data.velocity += 1.0
		#TEST
		if(player_data.steering_velocity > -velocity.x):
			velocity += Vector2(-player_data.steering_velocity/5, 0)
	else:
		if(abs(velocity.x) > 1):
			velocity.x = lerp(velocity.x, 0.0, 0.15)
		else:
			velocity.x = 0

func _handle_smashing() -> void:
	if(Input.is_action_pressed("smash")):
		pass

func _on_player_dead() -> void:
	player_data.velocity = 0
	player_data.steering_velocity = 0

func _on_player_damaged(damage: float) -> void:
	player_data.hp -= damage
