class_name RPlayerData
extends Resource

signal player_stamina_waste()

@export var start_velocity: float = 150:
	set(value):
		if(value <= 0):
			start_velocity = 10
		else:
			start_velocity = value
@export var max_velocity: float = 300:
	set(value):
		if(value <= 0):
			max_velocity = 0
		else:
			max_velocity = value
@export var max_stamina: float = 200
@export var steering_velocity: float = 160:
	set(value):
		if(value <= 0):
			steering_velocity = 0
		else:
			steering_velocity = value
@export var default_start_time: int = 15

@export var accelerate_per_second: float = 75:
	set(value):
		if(value <=0):
			accelerate_per_second = 10
		else:
			accelerate_per_second = value
var stamina: float:
	set(value):
		if(value <= 0):
			player_stamina_waste.emit()
			stamina = 0
		else:
			stamina = value
var current_velocity: float:
	set(value):
		if(value <= 0):
			current_velocity = 0
		elif(value > max_velocity):
			current_velocity = max_velocity
		else:
			current_velocity = value

func _init() -> void:
	current_velocity = start_velocity
	stamina = max_stamina
