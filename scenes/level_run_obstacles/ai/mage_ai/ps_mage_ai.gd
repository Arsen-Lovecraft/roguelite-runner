class_name MageAI 
extends Area2D

signal mage_attacked()
signal mage_died()

@export var cooldown: float = 2.0

@onready var _damage_trait: RDamageTrait = RDamageTrait.new().duplicate()
@onready var _cooldown_timer: Timer = %CooldownTimer

func _ready() -> void:
	_cooldown_timer.wait_time = cooldown
	_connect_signals()

func _connect_signals() -> void:
	if body_entered.connect(_on_body_entered) : printerr("Fail: ",get_stack())
	if _cooldown_timer.timeout.connect(_on_cooldown_timeout) : printerr("Fail: ",get_stack())

func _on_body_entered(body: Node2D) -> void:
	if(body is Player):
		_damage_trait.player_damaged.emit(_damage_trait.damage)
		EventBus.player_damaged.emit(_damage_trait.damage)
		queue_free()

func _on_cooldown_timeout() -> void:
	pass
