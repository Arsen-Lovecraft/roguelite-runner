class_name WinArea
extends Area2D

func _ready() -> void	:
	_connect_signals()

func _connect_signals() -> void:
	if (self as Area2D).body_entered.connect(_on_body_entered): printerr("Fail: ",get_stack())

func _on_body_entered(body: Node2D) -> void:
	if(body is Player):
		##TODO Decouple
		EventBus.player_completed_level.emit()
