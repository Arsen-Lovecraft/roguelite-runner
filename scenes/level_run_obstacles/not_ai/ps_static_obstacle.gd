class_name StaticObstacle
extends Area2D

@onready var _static_obstacle_animation_player: AnimationPlayer = %StaticObstacleAnimationPlayer

@onready var damage_trait: RDamageTrait = preload("res://godot_resources/damage_traits/static_obstacle_damage_trait.tres")

func  _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	if body_entered.connect(_on_body_entered) : printerr("Fail: ",get_stack())

func _activate_trap() -> void:
	_static_obstacle_animation_player.play("emerge")

## This function is designed to be called within [AnimationPlayer]
func _try_damage_player() -> void:
	for i: Node2D in self.get_overlapping_bodies():
		if(i is Player):
			damage_trait.player_damaged.emit(damage_trait.damage)

func _on_body_entered(body: Node2D) -> void:
	if( body is Player):
		_activate_trap()
