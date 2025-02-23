extends AnimationPlayer

@onready var _mage_ai: MageAI = self.get_parent() as MageAI

func _ready() -> void:
	_connect_signals()
	(self as AnimationPlayer).play("down_idle")

func _connect_signals() -> void:
	if _mage_ai.mage_attacked.connect(_on_mage_attacked) : printerr("Fail: ", get_stack())
	if _mage_ai.mage_died.connect(_on_mage_died) : printerr("Fail: ", get_stack())

func _on_mage_attacked() -> void:
	(self as AnimationPlayer).play("down_attack")
	await (self as AnimationPlayer).animation_finished
	(self as AnimationPlayer).play("down_idle")

func _on_mage_died() -> void:
	(self as AnimationPlayer).play("down_hurt")
	await (self as AnimationPlayer).animation_finished
	(self as AnimationPlayer).play("down_death")
