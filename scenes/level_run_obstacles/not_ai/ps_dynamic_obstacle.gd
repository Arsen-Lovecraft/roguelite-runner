class_name DynamicObstacle
extends IDangerousArea2D


func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	if body_entered.connect(_on_body_entered) : printerr("Fail: ",get_stack())

func _on_body_entered(body: Node2D) -> void:
	if( body is Player):
		player_damaged.emit(damage)
		EventBus.player_damaged.emit(damage)
		queue_free()
