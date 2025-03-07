class_name Player
extends CharacterBody2D

signal moved_right()
signal moved_left()
signal moved_up()
signal smashed()
signal player_is_damaged()
signal lost()

var player_data: RPlayerData = preload("res://godot_resources/r_default_player_data.tres")
@onready var smash_area_2d: SmashArea2D = %SmashArea2D

func _ready() -> void:
	self.add_to_group("player")
	_connect_signals()
	player_data._init()

func _physics_process(delta: float) -> void:
	_move_player(delta)
	_handle_steering()
	_handle_smashing()
	velocity.x = clamp(velocity.x, -player_data.steering_velocity, player_data.steering_velocity)
	velocity.y = clamp(velocity.y, -player_data.current_velocity, 0)
	@warning_ignore("return_value_discarded")
	move_and_slide()

func _connect_signals() -> void:
	if player_data.player_stamina_waste.connect(_on_player_stamina_waste): printerr("Fail: ",get_stack())

func _move_player(delta: float) -> void:
	if(velocity.y < player_data.current_velocity):
		velocity += Vector2(0,-player_data.accelerate_per_second * delta)
	elif(velocity.y > player_data.current_velocity):
		velocity -= Vector2(0,-player_data.accelerate_per_second * delta)

func _handle_steering() -> void:
	if(Input.is_action_pressed("turn_right")):
		if(player_data.steering_velocity > velocity.x):
			velocity += Vector2(player_data.steering_velocity/5, 0)
			moved_right.emit()
	elif(Input.is_action_pressed("turn_left")):
		if(player_data.steering_velocity > -velocity.x):
			velocity += Vector2(-player_data.steering_velocity/5, 0)
			moved_left.emit()
	else:
		if(abs(velocity.x) > 1):
			velocity.x = lerp(velocity.x, 0.0, 0.15)
			moved_up.emit()
		else:
			velocity.x = 0

func _handle_smashing() -> void:
	if(Input.is_action_just_pressed("smash")):
		if (smash_area_2d.get_closest_enemy() != null):
			var closest_enemy: Area2D = smash_area_2d.get_closest_enemy()
			closest_enemy.disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
			Utility.slow_motion(0.5, 0.5)
			self.global_position = lerp(self.global_position,closest_enemy.global_position,0.81)
			closest_enemy.queue_free()
			smashed.emit()

func _on_player_stamina_waste() -> void:
	if(player_data.stamina == 0):
		return
	player_data.current_velocity -= 75
	if(player_data.current_velocity <= 10):
		player_data.current_velocity = 10
	await get_tree().create_timer(5.0).timeout
	player_data.stamina = player_data.max_stamina
	if(player_data.current_velocity != 0):
		player_data.current_velocity += 75

func _on_lost() -> void:
	lost.emit()
	player_data.max_velocity = 0
	player_data.steering_velocity = 0

func _on_player_is_damaged(damage: float) -> void:
	player_is_damaged.emit()
	player_data.stamina -= damage
