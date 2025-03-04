class_name UtilityNode
extends Node

func slow_motion(duration: float, scale: float) -> void:
	Engine.time_scale = scale
	await get_tree().create_timer(duration * scale).timeout
	Engine.time_scale = 1.0

func get_key_string_for_action(action_name: String, which_control: int = 0) -> String:
	var actions: Array[StringName] = InputMap.get_actions()
	for i: StringName in actions:
		if(i == action_name):
				if(InputMap.action_get_events(i).size() < which_control + 1):
					return "Error InputMapping get__key_string_for_action: there is no control with this index"
				else:
					return "\"" + InputMap.action_get_events(i)[which_control].as_text() + "\""
	return "Error InputMapping get__key_string_for_action: action is not found"
