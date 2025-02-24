class_name Player
extends CharacterBody2D

signal moved_right()
signal moved_left()
signal moved_up()
signal smashed()

var player_data: RPlayerData = preload("res://godot_resources/r_default_player_data.tres")
@onready var smash_area_2d: SmashArea2D = %SmashArea2D

func _ready() -> void:
	self.add_to_group("player")
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
	if player_data.player_stamina_waste.connect(_on_player_stamina_waste): printerr("Fail: ",get_stack())
	if EventBus.life_time_left.connect(_on_life_time_left): printerr("Fail: ",get_stack())
	if EventBus.player_damaged.connect(_on_player_damaged): printerr("Fail: ",get_stack())

func _move_player() -> void:
	if(player_data.velocity > -velocity.y):
		velocity += Vector2(0,-player_data.velocity/5)

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
			closest_enemy.monitoring = false
			Utility.slow_motion(0.8, 0.2)
			self.global_position = lerp(self.global_position,closest_enemy.global_position,0.95)
			closest_enemy.queue_free()
			player_data.velocity += 15
			smashed.emit()

func _on_player_stamina_waste() -> void:
	player_data.velocity -= 75
	if(player_data.velocity <= 10):
		player_data.velocity = 10
	player_data.stamina = player_data.max_stamina
	await get_tree().create_timer(5.0).timeout
	if(player_data.velocity != 0):
		player_data.velocity += 75

func _on_life_time_left() -> void:
	player_data.velocity = 0
	player_data.steering_velocity = 0

func _on_player_damaged(damage: float) -> void:
	player_data.stamina -= damage
