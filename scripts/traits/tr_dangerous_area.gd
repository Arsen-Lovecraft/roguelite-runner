class_name RDamageTrait
extends Resource

@warning_ignore("unused_signal")
signal player_damaged(damage: float)

@export var damage: float = 20:
	set(value):
		if(value<=0):
			damage = 0
		else:
			damage = value
