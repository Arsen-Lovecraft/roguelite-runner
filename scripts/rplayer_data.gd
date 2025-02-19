class_name RPlayerData
extends Resource

signal player_dead()

@export var speed: float = 150
@export var hp: int = 2:
	set(value):
		if(value <= 0):
			player_dead.emit()
		hp = value
@export var steering_velocity: float = 160

@export var smash_cooldown: float = 3.0
@export var smash_power: int = 2
