extends Node

signal onTestSignal(oldValue : int, newValue : int)

func _unhandled_input(event: InputEvent) -> void: 
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
