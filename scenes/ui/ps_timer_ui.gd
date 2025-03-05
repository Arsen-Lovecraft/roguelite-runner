class_name UITimer
extends Control

@onready var time_label: Label = %TimeLabel

func _ready() -> void:
	#TODO	 private access
	(get_tree().get_first_node_in_group("run_controller") as RunController)._life_timer.time_updated.connect(_on_timer_updated)
	(get_tree().get_first_node_in_group("run_controller") as RunController).won.connect(_on_won)
	(get_tree().get_first_node_in_group("run_controller") as RunController).lost.connect(_on_lost)
	

func _on_timer_updated(time: int) -> void:
	time_label.text = "Time: " + str(time)

func _on_won() -> void:
	time_label.text = "Win!"   
	(get_tree().get_first_node_in_group("run_controller") as RunController)._life_timer.time_updated.disconnect(_on_timer_updated)
	
func _on_lost() -> void:
	time_label.text = "Time is out. You lost!"
	(get_tree().get_first_node_in_group("run_controller") as RunController)._life_timer.time_updated.disconnect(_on_timer_updated)
