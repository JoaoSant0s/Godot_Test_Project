extends Node

signal onTestSignal(oldValue : int, newValue : int)

func _unhandled_input(_event: InputEvent) -> void: 
	if Input.is_action_just_pressed("close_game"):
		get_tree().quit()
