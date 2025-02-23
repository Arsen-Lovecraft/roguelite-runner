extends AnimationPlayer

@onready var _melee_parent: MeleeAI = self.get_parent() as MeleeAI

func _physics_process(_delta: float) -> void:
	if(_melee_parent.velocity < 0):
		(self as AnimationPlayer).play("left_walk")
	elif(_melee_parent.velocity >= 0):
		(self as AnimationPlayer).play("right_walk")
