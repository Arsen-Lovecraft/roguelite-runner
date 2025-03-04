class_name UISmashCue
extends Control

var _smash_area_2d: SmashArea2D

@onready var _target_mark_texture_rect: TextureRect = %TextureMark
@onready var input_cue: Control = %InputCue
@onready var input_cue_label: Label = %InputCueLabel

func _ready() -> void:
	_smash_area_2d = get_tree().get_first_node_in_group("smash_area_2d")
	call_deferred("reparent",get_tree().current_scene)
	input_cue_label.text = Utility.get_key_string_for_action("smash",1)
	print(input_cue_label.text =="\"Space (Physical)\"")
	if(input_cue_label.text =="\"Space (Physical)\""):
		input_cue_label.text = "Space"

func _physics_process(delta: float) -> void:
	var enemy: Area2D = _smash_area_2d.get_closest_enemy()
	if(enemy != null):
		input_cue.global_position = _smash_area_2d.global_position
		for node_sprite: Node in enemy.get_children():
			if(node_sprite is Sprite2D):
				_target_mark_texture_rect.size = (node_sprite as Sprite2D).get_rect().size * 1.5
				_target_mark_texture_rect.pivot_offset = _target_mark_texture_rect.size/2
				_target_mark_texture_rect.global_position = (node_sprite as Sprite2D).global_position - _target_mark_texture_rect.size/2
		_target_mark_texture_rect.show()
		input_cue.show()
	else:
		_target_mark_texture_rect.hide()
		input_cue.hide()
