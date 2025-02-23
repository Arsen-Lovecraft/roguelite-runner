class_name RDamageTrait
extends Resource

signal player_damaged(damage: float)

@export var damage: float = 20:
	set(value):
		if(value<=0):
			damage = 0
		else:
			damage = value
