class_name DynamicObstacle
extends Area2D

@onready var damage_trait: RDamageTrait = RDamageTrait.new().duplicate()

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	if body_entered.connect(_on_body_entered) : printerr("Fail: ",get_stack())

func _on_body_entered(body: Node2D) -> void:
	if( body is Player):
		damage_trait.player_damaged.emit(damage_trait.damage)
		EventBus.player_damaged.emit(damage_trait.damage)
		queue_free()
