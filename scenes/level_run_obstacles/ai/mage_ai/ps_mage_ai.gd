class_name MageAI 
extends Area2D

signal mage_attacked()
signal mage_died()

@export var cooldown: float = 6.0
@export var fireball_velocity: float = 80
@export var shot_in_advance_time: float = 1.25

@onready var _damage_trait: RDamageTrait = RDamageTrait.new().duplicate()
@onready var _cooldown_timer: Timer = %CooldownTimer
@onready var _fireball_ps: PackedScene = preload("res://scenes/level_run_obstacles/ai/mage_ai/ps_fireball.tscn")

func _ready() -> void:
	_cooldown_timer.wait_time = cooldown
	_connect_signals()

func _connect_signals() -> void:
	if body_entered.connect(_on_body_entered): printerr("Fail: ",get_stack())
	if _cooldown_timer.timeout.connect(_on_cooldown_timeout): printerr("Fail: ",get_stack())

func _on_body_entered(body: Node2D) -> void:
	if(body is Player):
		_damage_trait.player_damaged.emit(_damage_trait.damage)
		EventBus.player_damaged.emit(_damage_trait.damage)
		mage_died.emit()
		queue_free()

func _on_cooldown_timeout() -> void:
	var player: Player = get_tree().get_first_node_in_group("player") as Player
	if(player is Player):
		var direction: Vector2 = self.global_position.direction_to(player.global_position + player.velocity * shot_in_advance_time)
		if( direction.y < 0):
			return
		var _fireball: Fireball = _fireball_ps.instantiate()
		_fireball.velocity = fireball_velocity
		_fireball.direction = direction
		_fireball.global_position = self.global_position
		get_tree().current_scene.add_child(_fireball)
		get_tree().current_scene.move_child(_fireball,0)
		mage_attacked.emit()
