class_name RPlayerData
extends Resource

signal player_stamina_waste()

@export var velocity: float = 150:
	set(value):
		if(value <= 0):
			velocity = 0
		else:
			velocity = value
@export var max_stamina: float = 200
@export var steering_velocity: float = 160:
	set(value):
		if(value <= 0):
			steering_velocity = 0
		else:
			steering_velocity = value
@export var default_start_time: int = 15

var stamina: float = 200:
	set(value):
		if(value <= 0):
			player_stamina_waste.emit()
			stamina = 0
		else:
			stamina = value
		print("Stamina: " + str(stamina))
