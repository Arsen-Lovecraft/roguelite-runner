class_name MeleeAI
extends Area2D

signal melee_ai_is_dead()

@export var move_distance: float = 200
@export var speed: float = 20

var velocity: float = 0.0

@onready var damage_trait: RDamageTrait = RDamageTrait.new().duplicate()

func _ready() -> void:
	velocity = [-speed,speed][randi_range(0,1)]
	_connect_signals()

func _physics_process(_delta: float) -> void:
	_handle_move(_delta)

func _connect_signals() -> void:
	if body_entered.connect(_on_body_entered) : printerr("Fail: ",get_stack())

func _handle_move(delta: float) -> void:
	if(velocity > 0):
		position.x += velocity * delta
	elif(velocity < 0):
		position.x += velocity * delta
	if(position.x > move_distance and velocity > 0):
		velocity = -velocity
	elif(position.x < -move_distance and velocity < 0):
		velocity = -velocity

func _on_body_entered(body: Node2D) -> void:
	if(body is Player):
		damage_trait.player_damaged.emit(damage_trait.damage)
		EventBus.player_damaged.emit(damage_trait.damage)
		queue_free()
