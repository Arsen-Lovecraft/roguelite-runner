class_name RPlayerData
extends Resource

signal player_dead()

@export var velocity: float = 150:
	set(value):
		if(value <= 0):
			velocity = 0
		else:
			velocity = value
@export var hp: int = 2:
	set(value):
		if(value <= 0):
			player_dead.emit()
		hp = value
@export var steering_velocity: float = 160:
	set(value):
		if(value <= 0):
			steering_velocity = 0
		else:
			steering_velocity = value

@export var smash_cooldown: float = 3.0
@export var smash_power: int = 2
