class_name WinArea
extends Area2D

signal player_completed_level()

func _ready() -> void:
	add_to_group("win_area")
	_connect_signals()

func _connect_signals() -> void:
	if (self as Area2D).body_entered.connect(_on_body_entered): printerr("Fail: ",get_stack())

func _on_body_entered(body: Node2D) -> void:
	if(body is Player):
		player_completed_level.emit()
