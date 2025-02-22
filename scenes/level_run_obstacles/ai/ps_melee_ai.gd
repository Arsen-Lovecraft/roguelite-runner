class_name MeleeAI
extends IDangerousArea2D

signal melee_ai_is_dead()

@export var move_distance: float = 200
@export var speed: float = 200

var velocity: float = 0.0

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
		player_damaged.emit(damage)
		EventBus.player_damaged.emit(damage)
		queue_free()
