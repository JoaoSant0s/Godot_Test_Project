extends Node

func _unhandled_input(_event: InputEvent) -> void: 
	if Input.is_action_just_pressed("close_game") and OS.get_name() != "Web":
		get_tree().quit()
