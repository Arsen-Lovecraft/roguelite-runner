class_name Fireball
extends Area2D

@onready var _damage_trait: RDamageTrait = preload("res://godot_resources/damage_traits/fireball_damage_trait.tres")
@onready var fireball_visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = %FireballVisibleOnScreenNotifier2D

var velocity: float = 20
var direction: Vector2 = Vector2(0,0)

func _ready() -> void:
	_connect_signals()

func _physics_process(delta: float) -> void:
	self.global_position += velocity * direction.normalized() * delta

func _connect_signals() -> void:
	if body_entered.connect(_on_body_entered) : printerr("Fail: ",get_stack())
	if fireball_visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exited) : printerr("Fail: ",get_stack())

func _on_body_entered(body: Node2D) -> void:
	if(body is Player):
		_damage_trait.player_damaged.emit(_damage_trait.damage)
		queue_free()

func _on_screen_exited() -> void:
	queue_free()
