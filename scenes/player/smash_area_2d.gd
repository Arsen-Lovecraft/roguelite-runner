class_name SmashArea2D
extends Area2D

@onready var _player: Player = get_parent() as Player

func get_closest_enemy() -> Area2D:
	var ret: Area2D = null
	var distance: float = 9999999.0
	for i: Area2D in get_overlapping_areas():
		if(i is MeleeAI or i is MageAI):
			if( _player.global_position.distance_to(i.global_position) < distance):
				distance = _player.global_position.distance_to(i.global_position)
				ret = i
	return ret
