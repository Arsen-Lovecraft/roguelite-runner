class_name DamageTraitsDispatcher
extends RefCounted

signal player_is_damaged(damage: float)

var _traits: Array[RDamageTrait]

func _init() -> void:
	_load_traits()
	_connect_signals()

func _load_traits() -> void:
	var dir: DirAccess = DirAccess.open("res://godot_resources/damage_traits/")
	print(dir)
	if(dir and !dir.list_dir_begin()):
		var file_name: String = dir.get_next()
		while (file_name != ""):
			if(not dir.current_is_dir() and (file_name.ends_with(".tres") or file_name.ends_with(".res"))):
				var full_path: String = "res://godot_resources/damage_traits/" + file_name
				var resource: Resource = load(full_path)
				if(resource is RDamageTrait):
					_traits.append(resource as RDamageTrait)
			file_name = dir.get_next()

func _connect_signals() -> void:
	for tr: RDamageTrait in _traits:
		if tr.player_damaged.connect(_on_player_damaged) : printerr("Fail: ", get_stack())

func _on_player_damaged(damage: float) -> void:
	player_is_damaged.emit(damage)
